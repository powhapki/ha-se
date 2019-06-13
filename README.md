Tech. Excercise for Hashicorp SE


## Tech Excercise Environment Overview
Tech. Exercise envrionment is based the following pages.

https://learn.hashicorp.com/vault/operations/ops-vault-ha-consul

https://learn.hashicorp.com/vault/operations/ops-deployment-guide

This environment consists of 2 Valut Server Instances (with consul agent), 3 Consul Server Instances and 1 PostgreSQL RDS Instance.

Vault Server will be configured as HA mode and use Consul as the storage backend.
For Vault dynmic secrets live demo, PostgreSQL will be used.


## Install Process
All of the provisioning will be done by Terraform. Shell Script is used for configuring each service this time.
Next time shell script will be replaced by one of the Configuration Management Tool. (Ansbile will be my choice)

1. Provision & Configure Consul Server Instances
2. Provision & Congfigure Vault Server, Consul agent
3. Provision RDS Instance

## Live Demo Process
