#!/bin/bash
#
# setup ether


set -euxo pipefail

# Variable Declaration

OS="xUbuntu_20.04"
VERSION="1.23"
KUBERNETES_VERSION="1.23.6-00"

sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get install apt-transport-https -y
sudo apt-get install curl -y
sudo apt-get update -y

# Install Java (OpenJDK 11)
sudo apt install openjdk-17-jre-headless openjdk-17-jdk-headless -y

# Install SSH
sudo apt-get install -y openssh-server

# Install nginx
sudo apt-get install -y nginx

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update packages
sudo apt-get update

# Make sure we install Docker from the Docker repo instead of the default Ubuntu repos
sudo apt-cache policy docker-ce

# Install Docker
sudo apt-get install -y docker-ce

# Install openssl
sudo apt-get install -y openssl

# Install vifm
sudo apt-get install -y vifm

# Install keyclock
cd /opt/
sudo wget https://github.com/keycloak/keycloak/releases/download/21.0.1/keycloak-21.0.1.tar.gz
sudo tar zxvf keycloak-21.0.1.tar.gz
sudo mv keycloak-21.0.1 keycloak

sudo apt install postgresql-client-common
sudo apt install postgresql postgresql-contrib -y


echo -e "\e[1;35m Vagrant install scripts completed Succesfully \e[0m"
