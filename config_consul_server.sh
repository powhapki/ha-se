#!/bin/bash


sudo mkdir --parents /etc/consul.d
sudo touch /etc/consul.d/consul.hcl

sudo cat <<EOF > /etc/consul.d/consul.hcl
datacenter = "dc1"
data_dir = "/opt/consul"
encrypt="$(consul keygen)"
EOF

sudo chown --recursive consul:consul /etc/consul.d
sudo touch /etc/consul.d/consul.hcl
sudo chmod 640 /etc/consul.d/consul.hcl
