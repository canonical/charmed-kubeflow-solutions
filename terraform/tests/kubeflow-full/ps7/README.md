# Deploying kubeflow-full on PS7

These steps create a VM on ProdStack 7 (PS7) with a single-node Canonical K8s cluster, a
Juju controller and S3 object storage, then deploy [`kubeflow-full`](../README.md) on it.
On PS7, all traffic to the internet goes through the egress proxy
`http://egress.ps7.internal:3128`, so every component that downloads something is
configured to use it.

| File | Purpose |
| ---- | ------- |
| [`setup-cluster.sh`](setup-cluster.sh) | Sets up Canonical K8s, a Juju controller and MicroCeph on the VM. |
| [`k8s-bootstrap.yaml`](k8s-bootstrap.yaml) | Canonical K8s bootstrap configuration, used by `setup-cluster.sh`. |
| [`configure-dns.sh`](configure-dns.sh) | Makes the external hostnames resolve inside the cluster after the deployment. |

## 1. Create the VM

From where you run Juju for your PS7 model, write the model configuration, with the proxy
settings and a minimal cloud-init, and apply it, which affects every machine created
afterwards in the model. Then create the VM:

```bash
cat > model-config.yaml << 'EOF'
http-proxy: 'http://egress.ps7.internal:3128'
https-proxy: 'http://egress.ps7.internal:3128'
no-proxy: '127.0.0.1,localhost,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16'
# Juju refuses the legacy proxy settings above together with the juju-* ones
juju-http-proxy: ''
juju-https-proxy: ''
cloudinit-userdata: |
  package_upgrade: true
  package_reboot_if_required: true
  write_files:
  - path: /etc/environment
    # Unlike on PS6, .canonical.com, .launchpad.net and .internal must go through the proxy
    content: |
      http_proxy='http://egress.ps7.internal:3128'
      https_proxy='http://egress.ps7.internal:3128'
      no_proxy='127.0.0.1,localhost,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.svc,.cluster.local'
      HTTP_PROXY='http://egress.ps7.internal:3128'
      HTTPS_PROXY='http://egress.ps7.internal:3128'
      NO_PROXY='127.0.0.1,localhost,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.svc,.cluster.local'
    append: true
  snap:
    commands:
      - snap wait system seed.loaded
      - snap set system proxy.http=http://egress.ps7.internal:3128 proxy.https=http://egress.ps7.internal:3128
EOF
juju model-config --file model-config.yaml
juju deploy --base ubuntu@24.04 --constraints "cores=8 mem=32G root-disk=150G" ubuntu kubeflow-full
```

The configuration is inline because the PS7 proxy refuses connections to
`raw.githubusercontent.com`.

The disk needs about 150 GB: besides the OS and the container images, the local storage of
Canonical K8s needs free space for the full size of every volume, about 80 GiB in total.

Wait until `juju status` shows the unit as active: in the meantime, cloud-init upgrades the
packages and may reboot the machine. Then log into the VM and check that cloud-init has
finished:

```bash
juju ssh kubeflow-full/0
cloud-init status --wait  # should print "status: done"
```

## 2. Set up the cluster

Setting up the cluster and deploying take a long time, and a dropped SSH connection stops
the commands running in it. To avoid that, you can run them in a `tmux` session, which
keeps running on the VM after a disconnection:

```bash
tmux new -s kubeflow
```

To leave the session without stopping it, press `Ctrl+b` then `d`. To return to it, for
example after logging in again, run `tmux attach -t kubeflow`.

Docker Hub limits anonymous image pulls per IP, and all of PS7 shares the same egress IP,
so pulling with a Docker Hub account is recommended. To do so, set these before the first
run of the script, using a read-only access token, since it ends up in the containerd
configuration of the VM:

```bash
export DOCKERHUB_USERNAME=<username>
read -rsp "Docker Hub access token: " DOCKERHUB_TOKEN && export DOCKERHUB_TOKEN && echo
```

Then clone this repository and run `setup-cluster.sh`:

```bash
git clone https://github.com/canonical/charmed-kubeflow-solutions.git
cd charmed-kubeflow-solutions/terraform/tests/kubeflow-full
ps7/setup-cluster.sh
```

The script, which skips the steps already done if you re-run it:

- installs `k8s`, `kubectl`, `juju`, `terraform`, `yq` and `lxd` as snaps, and holds their
  refreshes;
- bootstraps Canonical K8s with `k8s-bootstrap.yaml`, configures Cilium for Istio ambient
  mode and waits for the load balancer;
- bootstraps the Juju controller `ck8s`, whose model defaults set the proxy of every model;
- runs MicroCeph with an S3 endpoint in an LXD container, then prints the endpoint and its
  credentials.

## 3. Define the variables and deploy

Write the input variables to `ps7.auto.tfvars.json`, which Terraform loads automatically
and git ignores. These values deploy the components validated on PS7:

```bash
S3_ENDPOINT=http://$(sudo lxc list ceph -c 4 -f csv | cut -d' ' -f1):80
cat > ps7.auto.tfvars.json << EOF
{
  "enable_kfp": true,
  "enable_katib": false,
  "enable_notebooks": true,
  "enable_tensorboard": false,
  "enable_training_v1": false,
  "enable_training_v2": false,
  "enable_mlflow": false,
  "enable_kserve": false,
  "enable_feast": false,
  "object_storage_mode": "S3",
  "s3_bucket_global": "bucket1",
  "s3_access_key_global": "foo",
  "s3_secret_key_global": "bar",
  "s3_endpoint_global": "$S3_ENDPOINT",
  "external_ui_hostname": "ui.kubeflow.com",
  "external_m2m_hostname": "api.kubeflow.com",
  "external_auth_hostname": "auth.kubeflow.com",
  "http_proxy": "http://egress.ps7.internal:3128",
  "https_proxy": "http://egress.ps7.internal:3128",
  "no_proxy": "127.0.0.1,localhost,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.svc,.cluster.local,.kubeflow.com",
  "github_profiles_automator_config": {
    "repository": "https://github.com/canonical/github-profiles-automator.git",
    "pmr-yaml-path": "tests/samples/pmr-sample-full.yaml",
    "git-revision": "rev295",
    "sync-period": "86400"
  }
}
EOF
```

- `enable_*` select the Kubeflow components.
- `s3_*_global` point to the MicroCeph S3 endpoint, with the credentials that
  `setup-cluster.sh` printed.
- `external_*_hostname` are the hostnames of the two Kubeflow gateways and of the Identity
  Platform. They need no public DNS record: `configure-dns.sh` makes them resolve inside
  the cluster.
- `http_proxy`, `https_proxy` and `no_proxy` set the proxy of the models that Terraform
  creates with these settings, while the other models get it from the controller's model
  defaults. `no_proxy` must include the domain of the hostnames: otherwise, in-cluster
  workloads such as oauth2-proxy send their requests for them to the PS7 proxy, which
  refuses them.

`configure-dns.sh` maps these hostnames by default, so it needs no settings. To use other
hostnames, also add their domain to `NO_PROXY_LIST` before running `setup-cluster.sh`, and
pass them to `configure-dns.sh` as `UI_HOSTNAME`, `M2M_HOSTNAME` and `AUTH_HOSTNAME`.

Then deploy and map the hostnames. `configure-dns.sh` first waits for the load balancers of
the gateways and of the Identity Platform, which get their IPs a few minutes after
`terraform apply` finishes:

```bash
source setup.sh
terraform init
terraform apply
ps7/configure-dns.sh
```

Watch the models until all their units are active, which can take a while:

```bash
juju status -m kubeflow --watch 5s  # likewise for istio-system, iam-core, iam and cos
```

To eventually confirm they're all active:

```bash
for model in istio-system iam-core iam cos kubeflow
do
    juju status -m $model
    printf "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
done
```

If oauth2-proxy is still not active a few minutes after `configure-dns.sh`, restart it with
`kubectl -n kubeflow delete pod oauth2-proxy-0`. If the VM restarts, check that CoreDNS
still has the hosts block with `kubectl -n kube-system get configmap ck-dns-coredns -o yaml`,
and re-run `configure-dns.sh` otherwise.
