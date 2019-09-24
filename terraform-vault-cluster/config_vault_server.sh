#!/bin/bash

local_ip=`echo $(hostname -I)|tr -d ''`
sudo mkdir -p /etc/vault.d /mnt/vault/data
sudo chown -R vault:vault /etc/vault.d /mnt/vault/data
sudo touch /etc/vault.d/vault_server.hcl
sudo chmod 640 /etc/vault.d/vault_server.hcl

sudo cat <<EOF > /etc/vault.d/vault_server.hcl
ui = true
listener "tcp" {
  address          = "0.0.0.0:8200"
  cluster_address  = "$local_ip:8201"
  tls_disable      = "true"
}
storage "file" {
  path = "/mnt/vault/data"
}

api_addr = "http://$local_ip:8200"
cluster_addr = "https://$local_ip:8201"
EOF
