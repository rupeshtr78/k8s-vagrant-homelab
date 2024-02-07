#!/bin/bash
#
# setup halyard

set -euxo pipefail

# Variable Declaration

OS="xUbuntu_20.04"
VERSION="1.23"
KUBERNETES_VERSION="1.23.6-00"
JAVA_PKG=https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz
JAVA_HOME=/usr/java/jdk-17
JAVA_SHA256=$(curl "$JAVA_PKG".sha256)
HAL_USER=vagrant
HOST_NAME=$(hostname)


# install JDK 17 
echo -e "\e[1;35m Installing java-17 \e[0m"
curl --output /tmp/jdk.tgz "$JAVA_PKG"
echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c
mkdir -p "$JAVA_HOME"
tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1
sudo update-alternatives --install /usr/bin/java java /usr/java/jdk-17/bin/java 1
java --version
echo -e "\e[1;35m Finished Installing Java-17 \e[0m"

# install halyard
sudo -i -u vagrant bash << EOF
whoami
export HAL_USER=$HAL_USER
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


echo -e "\e[1;35m Replace the links with the archive address \e[0m"
sudo sed -i -re 's/([a-z]{2}.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
sudo apt-get update -y

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
