#!/bin/bash
sudo -i -u postgres psql <<EOF
CREATE DATABASE keycloak;
CREATE USER keycloak WITH PASSWORD 'admin';
GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak;
EOF

sudo systemctl daemon-reload # any change you do on the keycloak.service file run this command after it
sudo systemctl start keycloak.service
sudo systemctl status keycloak.service


echo -e "\e[1;35m Vagrant keyckoak scripts completed Succesfully \e[0m"
