#!/usr/bin/env bash
# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.
#
# Makes the external hostnames of kubeflow-full resolve inside the cluster to the IPs of
# their load balancers, through a hosts block in CoreDNS, as the CI does. In-cluster
# workloads such as oauth2-proxy and istiod need it to reach the Identity Platform. Run it
# after terraform apply (see README.md); re-running it replaces the block.

set -euo pipefail
trap 'echo "ERROR: line $LINENO: $BASH_COMMAND" >&2' ERR

# The values of the external_*_hostname Terraform variables
UI_HOSTNAME=${UI_HOSTNAME:-ui.kubeflow.com}
M2M_HOSTNAME=${M2M_HOSTNAME:-api.kubeflow.com}
AUTH_HOSTNAME=${AUTH_HOSTNAME:-auth.kubeflow.com}

kubectl() { sudo k8s kubectl "$@"; }

# Prints the IP of a LoadBalancer Service, waiting for it to get one
lb_ip() {
  local ip
  for _ in $(seq 90); do
    ip=$(kubectl -n "$1" get service "$2" -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)
    if [[ -n $ip ]]; then
      echo "$ip"
      return
    fi
    sleep 10
  done
  echo "Service $2 in namespace $1 has no load balancer IP." >&2
  return 1
}

ui_ip=$(lb_ip kubeflow istio-ingress-k8s-ui-istio)
m2m_ip=$(lb_ip kubeflow istio-ingress-k8s-m2m-istio)
auth_ip=$(lb_ip iam-core traefik-lb)

patch=$(kubectl -n kube-system get configmap ck-dns-coredns -o json | python3 -c '
import json, re, sys

marker = "    # kubeflow-full external hostnames\n"
corefile = json.load(sys.stdin)["data"]["Corefile"]
corefile = re.sub(re.escape(marker) + r"    hosts \{\n.*?\n    \}\n", "", corefile, flags=re.S)
# CoreDNS accepts a single hosts block per server block
if re.search(r"^\s*hosts\b", corefile, flags=re.M):
    sys.exit("CoreDNS already has a hosts block: remove it from ConfigMap ck-dns-coredns, then re-run.")
entries = "".join(f"        {ip} {host}\n" for ip, host in zip(sys.argv[1::2], sys.argv[2::2]))
block = marker + "    hosts {\n" + entries + "        fallthrough\n    }\n"
start = corefile.index("{\n") + 2
print(json.dumps({"data": {"Corefile": corefile[:start] + block + corefile[start:]}}))
' "$ui_ip" "$UI_HOSTNAME" "$m2m_ip" "$M2M_HOSTNAME" "$auth_ip" "$AUTH_HOSTNAME")
kubectl -n kube-system patch configmap ck-dns-coredns --type merge -p "$patch"
kubectl -n kube-system rollout restart deployment coredns
kubectl -n kube-system rollout status deployment coredns --timeout 5m

printf '%s -> %s\n' "$UI_HOSTNAME" "$ui_ip" "$M2M_HOSTNAME" "$m2m_ip" "$AUTH_HOSTNAME" "$auth_ip"
