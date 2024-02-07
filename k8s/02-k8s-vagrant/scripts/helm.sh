#!/bin/bash

MASTER_IP="192.168.2.130"
NODENAME=$(hostname -s)
POD_CIDR="10.42.0.0/16"
CILIUM_VERSION="1.14.4"
# Install Cilium wiht its helm chart
helm repo add cilium https://helm.cilium.io/
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
echo "Helm Repositories Added Successfully 👍"

helm upgrade --install cilium cilium/cilium \
--version $CILIUM_VERSION \
--namespace kube-system \
--set l2announcements.enabled=true \
--set ingressController.enabled=true \
--set ingressController.loadbalancerMode=dedicated \
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

while [ "$(kubectl get pods -n kube-system -l k8s-app=cilium -o jsonpath='{.items[*].status.containerStatuses[*].ready}')" != "true" ]; do
  echo "Waiting for cilium to be ready ⏳"
  sleep 5
done

echo "Cilium Helm Chart Installed Successfully 👍" 

helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--set nfs.server=192.168.2.130 \
--set nfs.path=/srv/pvdata \
--set storageClass.name=k8s-nfs-class \
--set storageClass.provisionerName=k8s-sigs.io/nfs-subdir-external-provisioner
echo "NFS Helm Chart Installed Successfully 👍"

# helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
# echo "Ingress Helm Chart Installed Successfully 👍"


helm install prometheus prometheus-community/prometheus \
--namespace prometheus \
--create-namespace \
--set server.persistentVolume.enabled="true" \
--set server.persistentVolume.storageClass="k8s-nfs-class" \
--set server.persistentVolume.size=2Gi \
--set server.persistentVolume.path=/srv/pvdata/prometheus \
--set alertmanager.enabled="false" 

echo "Prometheus Helm Chart Installed Successfully 👍"

kubectl label node $(hostname -s) bgp-peering=true
kubectl create namespace rupesh
echo "Master Node Labeled Successfully 👍"
