#!/bin/bash
#
# setup pihole


set -euxo pipefail

# Variable Declaration


sudo apt-get -y install software-properties-common
sudo apt-get update -y
sudo apt-get install git -y




echo -e "\e[1;35m Vagrant up completed Succesfully \e[0m"