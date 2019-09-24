#!/bin/bash

local_ip=`echo $(hostname -I)|tr -d ''`
sudo mkdir --parents /etc/vault.d
sudo touch /etc/vault.d/vault_server.hcl
sudo chown --recursive vault:vault /etc/vault.d
sudo chmod 640 /etc/vault.d/vault_server.hcl
sudo mkdir --parents /mnt/vault
sudo touch /mnt/vault/data
sudo chown --recursive vault:vault /mnt/vault

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
