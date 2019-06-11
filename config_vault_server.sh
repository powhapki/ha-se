#!/bin/bash

local_ip=`echo $(hostname -I)|tr -d ''`
sudo mkdir --parents /usr/local/etc/vault/
sudo touch /usr/local/etc/consul/vault_server.hcl


sudo cat <<EOF > /usr/local/etc/consul/vault_server.hcl
listener "tcp" {
  address          = "0.0.0.0:8200"
  cluster_address  = "$local_ip:8201"
  tls_disable      = "true"
}

storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}

api_addr = "http://$local_ip:8200"
cluster_addr = "https://$local_ip:8201"

EOF

sudo chown --recursive vault:vault /var/run/vault
sudo touch /usr/local/etc/vault/vault_server.hcl
sudo chmod 640 /usr/local/etc/vault/vault_server.hcl
