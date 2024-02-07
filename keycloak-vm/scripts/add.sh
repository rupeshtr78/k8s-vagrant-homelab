#!/bin/bash
# Add vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create .vim directory if it doesn't exist
mkdir -p ~/.vim
mkdir -p /opt/keycloak/certs

# Copy .vmrc and .vim/plugins.vim files to ~/.vim directory
cp /vagrant/files/.vimrc ~/.vim/
cp /vagrant/files/plugins.vim ~/.vim/
cp /vagrant/files/ca.crt /opt/keycloak/certs
cp /vagrant/files/keycloak.crt /opt/keycloak/certs
cp /vagrant/files/keycloak.key /opt/keycloak/certs

# create a keycloak user and group
sudo groupadd keycloak
sudo useradd -r -g keycloak -d /opt/keycloak -s /sbin/nologin keycloak

# set the directory ownership
sudo chown -R keycloak: /opt/keycloak
sudo chmod o+x /opt/keycloak/bin
sudo chown keycloak: /opt/keycloak/bin/kc.sh

sudo cp /vagrant/files/keycloak.service /etc/systemd/system

echo -e "\e[1;35m Vagrant add scripts completed Succesfully \e[0m"
