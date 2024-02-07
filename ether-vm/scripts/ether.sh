#!/bin/bash
#
# setup ether


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


#Install jdk8
echo -e "\e[1;35m Installing ethereum \e[0m"
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update -y
sudo apt-get -y install ethereum


echo -e "\e[1;35m Vagrant up completed Succesfully \e[0m"