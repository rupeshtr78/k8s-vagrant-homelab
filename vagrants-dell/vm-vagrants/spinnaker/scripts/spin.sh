#!/bin/bash
#
# setup halyard

set -euxo pipefail

# Variable Declaration

OS="xUbuntu_20.04"
VERSION="1.23"
KUBERNETES_VERSION="1.23.6-00"

echo -e "\e[1;35m Replace the sources with the archive address \e[0m"
sudo sed -i -re 's/([a-z]{2}.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update -y

#Install jdk8
echo -e "\e[1;35m Installing Java \e[0m"
sudo apt-get install openjdk-11-jdk -y

J_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
echo export JAVA_HOME=$J_HOME >> /home/vagrant/.profile
java --version
echo -e "\e[1;35m Java Install Complete \e[0m"

# install halyard
sudo -i -u vagrant bash << EOF
whoami
echo "making halyard directory"
mkdir -p /home/vagrant/halyard
cd /home/vagrant/halyard

echo -e "\e[1;35m Downloading halyard \e[0m"
curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh
chmod +x InstallHalyard.sh

echo -e "\e[1;35m Installing halyard \e[0m"
sudo bash InstallHalyard.sh --user vagrant -y
echo "Halyard version $(hal -v) succesfully installed"

echo -e "\e[1;35m Finished Installing halyard \e[0m"
EOF

#Install nfs-common
echo -e "\e[1;35m Installing nfs-common \e[0m"
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo apt-get install -y nfs-common

#Install Kubectl and copy kubecongig
echo -e "\e[1;35m Installing kubectl \e[0m"
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl="$KUBERNETES_VERSION"
sudo apt-get update -y
sudo apt-get install -y jq

sudo -i -u vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
kubectl config current-context
kubectl get nodes
echo -e "\e[1;35m Finished Installing kubectl \e[0m"
EOF

echo "Hostname:  $(hostname)"
IP_ADDR="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
echo -e "IP Address: $IP_ADDR"

echo -e "\e[1;35m Vagrant up completed Succesfully \e[0m"
