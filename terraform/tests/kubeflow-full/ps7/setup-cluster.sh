#!/usr/bin/env bash
# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.
#
# Sets up a PS7 VM created as described in README.md to host kubeflow-full: a single-node
# Canonical K8s cluster, a Juju controller on it and S3 object storage (MicroCeph in an LXD
# container). Run it as the user that will run Juju and Terraform, not as root. It
# skips the steps already done, so it can be re-run after a failure.
#
# It does not use Concierge, unlike the CI: Concierge does not have an option to set the Cilium
# tunnel port directly, without which the cluster never becomes ready on PS7 because the port
# Cilium uses for its tunnel is already taken by Juju's overlay network, so bootstrapping Canonical
# K8s directly is necessary.

set -euo pipefail
trap 'echo "ERROR: line $LINENO: $BASH_COMMAND" >&2' ERR

# Settings, each overridable through an environment variable of the same name
PROXY=${PROXY:-http://egress.ps7.internal:3128}
# Includes the domain of the external hostnames in the Terraform variables, which the
# workloads must reach directly rather than through the proxy
NO_PROXY_LIST=${NO_PROXY_LIST:-127.0.0.1,localhost,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.svc,.cluster.local,.kubeflow.com}
S3_ACCESS_KEY=${S3_ACCESS_KEY:-foo}
S3_SECRET_KEY=${S3_SECRET_KEY:-bar}
# Optional: DOCKERHUB_USERNAME and DOCKERHUB_TOKEN, to pull images from Docker Hub with an
# account rather than anonymously. Only used when bootstrapping the cluster.

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
step() { printf '\n==> %s\n' "$*"; }

if [[ $EUID -eq 0 ]]; then
  echo "Run this script as the user that will run Juju and Terraform, not as root." >&2
  exit 1
fi

step "Installing snaps"
sudo snap install k8s --classic --channel=1.32-classic/stable
sudo snap install kubectl --classic --channel=1.32/stable
sudo snap install juju --channel=3.6/stable
sudo snap install terraform --classic --channel=latest/stable
sudo snap install yq
sudo snap install lxd --channel=latest/stable
# Keep automatic refreshes from restarting services, e.g. in the middle of a test
sudo snap refresh --hold >/dev/null

step "Configuring the host"
sudo tee /etc/sysctl.d/99-kubeflow.conf >/dev/null << EOF
fs.inotify.max_user_instances=1280
fs.inotify.max_user_watches=655360
EOF
sudo sysctl --system >/dev/null
# containerd pulls all the container images
sudo mkdir -p /etc/systemd/system/snap.k8s.containerd.service.d
sudo tee /etc/systemd/system/snap.k8s.containerd.service.d/http-proxy.conf >/dev/null << EOF
[Service]
Environment="HTTP_PROXY=$PROXY"
Environment="HTTPS_PROXY=$PROXY"
Environment="NO_PROXY=$NO_PROXY_LIST"
Environment="http_proxy=$PROXY"
Environment="https_proxy=$PROXY"
Environment="no_proxy=$NO_PROXY_LIST"
EOF
sudo systemctl daemon-reload

step "Bootstrapping Canonical K8s"
if [[ $(sudo k8s status 2>&1 || true) == *"not part of a Kubernetes cluster"* ]]; then
  # Rejected credentials would make every image pull from Docker Hub fail, but only later on
  if [[ -n ${DOCKERHUB_USERNAME:-} && -n ${DOCKERHUB_TOKEN:-} ]] &&
    ! curl -fsS -o /dev/null --proxy "$PROXY" -K - 'https://auth.docker.io/token?service=registry.docker.io' \
      <<< "user = \"$DOCKERHUB_USERNAME:$DOCKERHUB_TOKEN\""; then
    echo "Docker Hub rejected DOCKERHUB_USERNAME and DOCKERHUB_TOKEN: set them again, then re-run." >&2
    exit 1
  fi
  {
    cat "$HERE/k8s-bootstrap.yaml"
    if [[ -n ${DOCKERHUB_USERNAME:-} && -n ${DOCKERHUB_TOKEN:-} ]]; then
      # Escaped for YAML single-quoted strings
      username=${DOCKERHUB_USERNAME//\'/\'\'}
      token=${DOCKERHUB_TOKEN//\'/\'\'}
      cat << EOF
extra-node-containerd-config:
  plugins:
    io.containerd.grpc.v1.cri:
      registry:
        configs:
          registry-1.docker.io:
            auth:
              username: '$username'
              password: '$token'
EOF
    fi
  } | sudo k8s bootstrap --file - --timeout 10m
else
  echo "This node is already part of a cluster."
fi
sudo k8s status --wait-ready --timeout 15m

step "Configuring Cilium for Istio ambient mode, as the CI does"
if [[ $(sudo k8s kubectl -n kube-system get configmap cilium-config -o jsonpath='{.data.bpf-lb-sock-hostns-only}') != true ]]; then
  sudo k8s kubectl -n kube-system patch configmap cilium-config --type merge \
    -p '{"data":{"bpf-lb-sock-hostns-only":"true","cni-exclusive":"false"}}'
  sudo k8s kubectl -n kube-system rollout restart daemonset cilium
fi
sudo k8s kubectl -n kube-system rollout status daemonset cilium --timeout 10m

step "Waiting for the load balancer"
# MetalLB cannot deploy until the node is ready, and k8s eventually stops retrying
for _ in $(seq 40); do
  [[ $(sudo k8s status 2>&1 || true) =~ load-balancer:[[:space:]]+enabled ]] && break
  sudo k8s enable load-balancer >/dev/null 2>&1 || true
  sleep 15
done
if ! [[ $(sudo k8s status 2>&1 || true) =~ load-balancer:[[:space:]]+enabled ]]; then
  echo "The load balancer is not enabled, see 'sudo k8s status'." >&2
  exit 1
fi

step "Bootstrapping the Juju controller"
mkdir -p ~/.kube && chmod 700 ~/.kube
# The strictly confined juju snap cannot create this directory itself
mkdir -p ~/.local/share/juju
# shellcheck disable=SC2024  # the kubeconfig belongs to the current user
(umask 077 && sudo k8s config > ~/.kube/config)
# Juju creates the controller's volume in the default storage class
timeout 600 bash -c 'until sudo k8s kubectl get storageclass | grep -q "(default)"; do sleep 5; done'
if juju show-controller ck8s >/dev/null 2>&1; then
  echo "The ck8s controller already exists."
else
  # Juju finds the "k8s" cloud in the "k8s" context of ~/.kube/config. The model defaults
  # set the proxy of every model, including those that Terraform creates without it.
  juju bootstrap k8s ck8s \
    --bootstrap-constraints root-disk=10G \
    --model-default "logging-config=<root>=INFO; unit=DEBUG" \
    --model-default "juju-http-proxy=$PROXY" \
    --model-default "juju-https-proxy=$PROXY" \
    --model-default "juju-no-proxy=$NO_PROXY_LIST"
fi

step "Setting up S3 object storage (MicroCeph in an LXD container), as the CI does"
sudo lxd waitready --timeout 270
if ! sudo lxc network show lxdbr0 >/dev/null 2>&1; then
  sudo lxd init --minimal
  sudo lxc network set lxdbr0 ipv6.address none
fi
sudo lxc config set core.proxy_http "$PROXY"
sudo lxc config set core.proxy_https "$PROXY"
if ! sudo lxc info ceph >/dev/null 2>&1; then
  sudo lxc init ubuntu:22.04 ceph -c limits.cpu=4 -c limits.memory=2GB -d root,size=5GB
  sudo lxc config set ceph cloud-init.user-data - << EOF
#cloud-config
runcmd:
  - snap wait system seed.loaded
  - snap set system proxy.http=$PROXY proxy.https=$PROXY
  - snap install microceph
  - snap refresh --hold
  - microceph cluster bootstrap
  - microceph disk add loop,1G,3
  - microceph enable rgw
EOF
fi
[[ $(sudo lxc list ceph -c s -f csv) == RUNNING ]] || sudo lxc start ceph
# timeout runs this loop in the background, where lxc exec would hang reading the terminal
timeout 300 bash -c 'until sudo lxc exec ceph -- id -u ubuntu </dev/null >/dev/null 2>&1; do sleep 1; done'
sudo lxc exec ceph -- cloud-init status --wait >/dev/null || true
ceph_ip=$(sudo lxc list ceph -c 4 -f csv | cut -d' ' -f1)
timeout 600 bash -c "until curl -s -o /dev/null --noproxy '*' http://$ceph_ip; do sleep 5; done"
if ! sudo lxc exec ceph -- microceph.radosgw-admin user info --uid kubeflow >/dev/null 2>&1; then
  sudo lxc exec ceph -- microceph.radosgw-admin user create --uid kubeflow --display-name kubeflow \
    --access-key="$S3_ACCESS_KEY" --secret-key="$S3_SECRET_KEY" >/dev/null
fi

step "Done"
cat << EOF
Juju controller: ck8s
S3 endpoint:     http://$ceph_ip:80
S3 access key:   $S3_ACCESS_KEY
S3 secret key:   $S3_SECRET_KEY
EOF
