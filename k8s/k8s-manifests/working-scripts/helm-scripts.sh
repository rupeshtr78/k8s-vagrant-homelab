#### NFS Server ########
sudo apt install nfs-kernel-server -y
sudo systemctl enable --now nfs-kernel-server.service
sudo mkdir -p /srv/{pvdata,data}
sudo chown -R nobody:nogroup /srv/{pvdata,data}

echo "/srv/pvdata 192.168.2.0/255.255.255.0(rw,sync,no_subtree_check,root_squash)" | sudo tee -a /etc/exports
echo "/srv/data 192.168.2.0/255.255.255.0(rw,sync,no_subtree_check,root_squash)" | sudo tee -a /etc/exports

sudo exportfs -a
sudo systemctl restart nfs-kernel-server

# https://adamtheautomator.com/ubuntu-nfs-server/

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner 
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--set nfs.server=192.168.2.130 \
--set nfs.path=/srv/pvdata \
--set storageClass.name=k8s-nfs-class \
--set storageClass.provisionerName=k8s-sigs.io/nfs-subdir-external-provisioner

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner 
helm upgrade --install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=192.168.2.130 --set nfs.path=/srv/pvdata --set storageClass.name=k8s-nfs-class --set storageClass.provisionerName=k8s-sigs.io/nfs-subdir-external-provisioner


# --namespace prometheus --create-namespace \
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

helm uninstall ingress-nginx -n ingress-nginx

kubectl expose deployment apple -n playground --type=NodePort --port=5678 --target-port=5678 --
kubectl expose deployment apple -n playground --type=LoadBalancer --port=2368

helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb --namespace metallb --create-namespace \
  --set configInline.address-pools[0].name=default \
  --set configInline.address-pools[0].protocol=layer2 \
  --set configInline.address-pools[0].addresses[0]=192.168.2.50-192.168.2.100


helm uninstall metallb -n metallb

config
address-pools:
- name: default
  protocol: layer2
  addresses:
  - 192.168.2.175-192.168.1.8

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus \
--namespace prometheus \
--create-namespace \
--set persistentVolume.enabled=true \
--set persistentVolume.storageClass="k8s-nfs-class" \
--set persistentVolume.size=2Gi

helm install prometheus prometheus-community/prometheus \
--namespace prometheus \
--create-namespace \
--set persistentVolume.enabled=true \
--set server.persistentVolume.storageClass="k8s-nfs-class" \
--set alertmanager.persistentVolume.storageClass="k8s-nfs-class"

helm upgrade --install prometheus prometheus-community/prometheus --namespace prometheus --set persistentVolume.enabled=false -f 

helm upgrade --install prometheus prometheus-community/prometheus --namespace prometheus --create-namespace -f



helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install grafana grafana/grafana  \
--namespace grafana  --create-namespace \
--set adminPassword='We12come' \
--set persistence.enabled=true  \
--set persistence.storageClassName="k8s-nfs-class" \
--set persistence.size=1Gi \
--set initChownData.enabled=false \
--set ingress.enabled=true \
--set ingress.ingressClassName=cilium \
--set datasources.”datasources\.yaml”.apiVersion=1 \
--set datasources.”datasources\.yaml”.datasources[0].name=Prometheus \
--set datasources.”datasources\.yaml”.datasources[0].type=prometheus  \
--set datasources.”datasources\.yaml”.datasources[0].url=http://prometheus-server.prometheus.svc.cluster.local \
--set datasources.”datasources\.yaml”.datasources[0].access=proxy \
--set datasources.”datasources\.yaml”.datasources[0].isDefault=true 


helm upgrade --install grafana grafana/grafana \
--namespace grafana  --create-namespace \
--set adminPassword='We12come' \
--set persistence.enabled=true  \
--set persistence.storageClassName="k8s-nfs-class" \
--set persistence.size=1Gi \
--set initChownData.enabled=false \
--set ingress.enabled=true \
--set ingress.ingressClassName=cilium \
--set 'datasources."datasources\.yaml".apiVersion'=1 \
--set 'datasources."datasources\.yaml".datasources[0].name'=Prometheus \
--set 'datasources."datasources\.yaml".datasources[0].type'=prometheus  \
--set 'datasources."datasources\.yaml".datasources[0].url'=http://prometheus-server.prometheus.svc.cluster.local \
--set 'datasources."datasources\.yaml".datasources[0].access'=proxy \
--set 'datasources."datasources\.yaml".datasources[0].isDefault'=true 


helm install grafana grafana/grafana --namespace grafana --set adminPassword='We12come' --set persistence.enabled=true

# 1. Get your 'admin' user password by running:

#    kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# 2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:

#    grafana.grafana.svc.cluster.local

#    Get the Grafana URL to visit by running these commands in the same shell:

#      export POD_NAME=$(kubectl get pods --namespace grafana -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
#      kubectl --namespace grafana port-forward $POD_NAME 3000


helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps --set useHelm3=true





kubectl create serviceaccount kubeapps-operator
kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator

kubectl get secret $(kubectl get serviceaccount kubeapps-operator -o jsonpath='{range .secrets[*]}{.name}{"\n"}{end}' | grep kubeapps-operator-token) -o jsonpath='{.data.token}' -o go-template='{{.data.token | base64decode}}' && echo

kubectl port-forward -n kubeapps svc/kubeapps 8080:80


#Datadog

helm install datadog-operator datadog/datadog-operator
kubectl create secret generic datadog-secret --from-literal api-key=We12come --from-literal app-key=We12come -n datadog
kubectl apply -f dd-agent.yaml -n datadog

kubectl delete datadogagent datadog
helm delete my-datadog-operator

#ingress#########
kubectl create ingress demo-localhost --class=nginx --rule="demo.localdev.me/*=demo:80" -n playground

# Local testing
# create a simple web server and the associated service:

kubectl create deployment demo --image=httpd --port=80
kubectl expose deployment demo

# create an ingress resource. The following example uses an host that maps to localhost:

kubectl create ingress demo-localhost --class=nginx \
  --rule="demo.localdev.me/*=demo:80"

# Now, forward a local port to the ingress controller:

kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 80

curl -D- http://192.168.1.3 -H 'Host: demo.localdev.me/'

kubectl create deployment nginx-test  --image quay.io/redhattraining/nginx:1.21 --port 80 -n playground

kubectl expose deployment apple --type LoadBalancer -n playground
kubectl expose deployment banana --type LoadBalancer -n playground

kubectl exec -i -t -n playground dnsutils -c dnsutils -- sh -c "clear; (bash || ash || sh)"

helm install stable/etcd-operator --name my-etcd-op  --namespace externa-dns --create-namespace


# etcd
helm upgrade --install etcd-release bitnami/etcd --namespace externa-dns --create-namespace  --set persistence.storageClass=hyper-nfs-class
helm uninstall etcd-release --namespace externa-dns
#/
# etcd can be accessed via port 2379 on the following DNS name from within your cluster:

#     etcd-release.externa-dns.svc.cluster.local

# To create a pod that you can use as a etcd client run the following command:

#     kubectl run etcd-release-client --restart='Never' \
     --image docker.io/bitnami/etcd:3.5.4-debian-11-r9 \
     --env ROOT_PASSWORD=$(kubectl get secret --namespace externa-dns etcd-release -o jsonpath="{.data.etcd-root-password}" | base64 -d) \
     --env ETCDCTL_ENDPOINTS="etcd-release.externa-dns.svc.cluster.local:2379" \
     --namespace externa-dns \
     --command -- sleep infinity

# Then, you can set/get a key using the commands below:

#     kubectl exec --namespace externa-dns -it etcd-release-client -- bash
#     etcdctl --user root:$ROOT_PASSWORD put /message Hello
#     etcdctl --user root:$ROOT_PASSWORD get /message

# To connect to your etcd server from outside the cluster execute the following commands:

#     kubectl port-forward --namespace externa-dns svc/etcd-release 2379:2379 &
#     echo "etcd URL: http://127.0.0.1:2379"

#  * As rbac is enabled you should add the flag `--user root:$ETCD_ROOT_PASSWORD` to the etcdctl commands. Use the command below to export the password:

export ETCD_ROOT_PASSWORD=$(kubectl get secret --namespace externa-dns etcd-release -o jsonpath="{.data.etcd-root-password}" | base64 -d)



    #spark operator

kubectl create namespace spark-apps

helm install spark-operator spark-operator/spark-operator \
--namespace spark-operator \
--create-namespace \
--set sparkJobNamespace=spark-apps \
--set webhook.enable=true


helm repo add stakater https://stakater.github.io/stakater-charts

helm repo update

helm install konfigurator stakater/konfigurator \
    --namespace konfigurator \
    --create-namespace \
   --set deployCRD=true 





# Install Cilium with its helm chart
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

# Install Cert Manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.12.0/cert-manager.yaml

helm repo add jetstack https://charts.jetstack.io

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.12.7 \ # specify a suitable version
  --set installCRDs=true

kubectl create secret tls ca-key-pair \
   --cert=server.crt \
   --key=server.key \
   --namespace=default


