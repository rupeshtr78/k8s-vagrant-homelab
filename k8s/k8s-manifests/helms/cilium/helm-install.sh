CILIUM_VERSION=1.14.4

helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium \
--version $CILIUM_VERSION \
--namespace kube-system \
--set kubeProxyReplacement=strict \
--set k8sServiceHost=$MASTER_IP \
--set k8sServicePort=6443   \
--set hubble.listenAddress=":4244" \
--set hubble.relay.enabled=true \
--set hubble.ui.enabled=true  

