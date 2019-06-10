#!/bin/bash

local_ip=`echo $(hostname -I)|tr -d ''`
sudo mkdir --parents /usr/local/etc/consul/
sudo touch /usr/local/etc/consul/server_agent.json


sudo cat <<EOF > /usr/local/etc/consul/server_agent.json
{
    "server" : true,
    "node_name" : "consul_$local_ip",
    "datacenter" : "dc1",
    "data_dir" : "/var/consul/data",
    "bind_addr" : "0.0.0.0",
    "client_addr" : "0.0.0.0",
    "advertise_addr" : "$local_ip",
    "bootstrap_expect" : 3,
    "retry_join" : ["172.31.60.101", "172.31.60.102", "172.31.60.103"],
    "ui" : true,
    "log_level" : "DEBUG",
    "enable_syslog" : true,
    "acl_enforce_version_8" : false
EOF
#encrypt="$(consul keygen)"

:'
sudo chown --recursive consul:consul /etc/consul.d
sudo touch /etc/consul.d/consul.hcl
sudo chmod 640 /etc/consul.d/consul.hcl
'


