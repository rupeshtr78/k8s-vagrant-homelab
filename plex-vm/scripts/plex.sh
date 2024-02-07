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


#Install Plex
curl https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | sudo tee /usr/share/keyrings/plexserver.gpg > /dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/plexserver.gpg] https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt update
sudo apt install plexmediaserver -y
sudo systemctl enable --now plexmediaserver

echo -e "\e[1;35m Vagrant up completed Succesfully \e[0m"