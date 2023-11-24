#!/bin/bash
#
# Setup for Control Plane (Master) servers

set -euxo pipefail

MASTER_IP="192.168.2.130"
NODENAME=$(hostname -s)
POD_CIDR="10.42.0.0/16"
CILIUM_VERSION="1.14.4"

sudo kubeadm config images pull

echo "Preflight Check Passed: Downloaded All Required Images"

# sudo kubeadm init --apiserver-advertise-address=$MASTER_IP \
#   --apiserver-cert-extra-sans=$MASTER_IP \
#   --pod-network-cidr=$POD_CIDR \
#   --node-name "$NODENAME" \
#   --ignore-preflight-errors Swap

sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --apiserver-cert-extra-sans=$MASTER_IP --pod-network-cidr=$POD_CIDR --node-name "$NODENAME" --ignore-preflight-errors Swap --skip-phases=addon/kube-proxy --control-plane-endpoint $MASTER_IP

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install helm
sudo snap install helm --classic

# Save Configs to shared /Vagrant location

# For Vagrant re-runs, check if there is existing configs in the location and delete it for saving new configuration.

config_path="/vagrant/configs"

if [ -d $config_path ]; then
  rm -f $config_path/*
else
  mkdir -p $config_path
fi

cp -i /etc/kubernetes/admin.conf /vagrant/configs/config
touch /vagrant/configs/join.sh
chmod +x /vagrant/configs/join.sh

kubeadm token create --ttl 0 --print-join-command > /vagrant/configs/join.sh

# Generete KUBECONFIG on the host
sudo cp -f /etc/kubernetes/admin.conf /vagrant/configs/config

# # Install Calico Network Plugin

# curl https://docs.projectcalico.org/manifests/calico.yaml -O

# kubectl apply -f calico.yaml


# Install Metrics Server

kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/metrics-server.yaml


sudo -i -u vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
EOF

sudo -i -u vagrant bash << EOF
sudo apt install nfs-kernel-server -y
sudo systemctl enable --now nfs-kernel-server.service
sudo mkdir -p /srv/{pvdata,data}
sudo chown -R nobody:nogroup /srv/{pvdata,data}
echo "/srv/pvdata 192.168.2.0/255.255.255.0(rw,sync,no_subtree_check,root_squash)" | sudo tee -a /etc/exports
echo "/srv/data 192.168.2.0/255.255.255.0(rw,sync,no_subtree_check,root_squash)" | sudo tee -a /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
EOF
