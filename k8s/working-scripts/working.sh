https://particule.io/en/blog/k8s-no-cloud/


cilium service list
cilium policy list
cilium endpoint list
cilium node list
cilium status
cilium bpf lb list
cilium monitor

kubectl -n kube-system exec ds/cilium -- cilium service list
kubectl -n kube-system exec ds/cilium -- cilium status --verbose

helm upgrade --install cilium cilium/cilium \
--version $CILIUM_VERSION \
--namespace kube-system \
--set l2announcements.enabled=true \
--set ipam.operator.clusterPoolIPv4PodCIDRList=$POD_CIDR \
--set kubeProxyReplacement=strict \
--set k8sServiceHost=$MASTER_IP \
--set k8sServicePort=6443 \
--set ipv4NativeRoutingCIDR=$POD_CIDR \
--set ipv4.enabled=true \
--set prometheus.enabled=true \
--set operator.prometheus.enabled=true \
--set hubble.enabled=true \
--set hubble.listenAddress=":4244" \
--set hubble.relay.enabled=true \
--set hubble.ui.enabled=true \
--set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}"

curl -H "Host: play.192.168.2.58.nip.io" --head http://192.168.2.76/apple explain

