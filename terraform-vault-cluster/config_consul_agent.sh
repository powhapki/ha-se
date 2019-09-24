#!/bin/bash

local_ip=`echo $(hostname -I)|tr -d ''`
sudo mkdir --parents /usr/local/etc/consul/
sudo touch /usr/local/etc/consul/server_agent.json


sudo cat <<EOF > /usr/local/etc/consul/server_agent.json
{
    "server" : false,
    "node_name" : "consul_c_$local_ip",
    "datacenter" : "dc1",
    "data_dir" : "/var/run/consul/data",
    "bind_addr" : "$local_ip",
    "client_addr" : "127.0.0.1",
    "retry_join" : ["172.31.60.101", "172.31.60.102", "172.31.60.103"],
    "log_level" : "DEBUG",
    "enable_syslog" : true,
    "acl_enforce_version_8" : false
}
EOF

sudo chown --recursive consul:consul /usr/local/etc/consul
sudo touch /usr/local/etc/consul/server_agent.json
sudo chmod 640 /usr/local/etc/consul/server_agent.json