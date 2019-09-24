# Provision the Vault cluster
***
When you use userdata for AWS, you can refer [user_data_4_poc](https://github.com/powhapki/ha-se/blob/master/terraform-vault-cluster/user_data_4_poc) as a sample input.


## Procedure for Vault Server Install and configure.
Run each scripts with the following orders.
1. [inst_vault.sh](https://github.com/powhapki/ha-se/blob/master/terraform-vault-cluster/inst_vault.sh)
2. [configure_vault_server.sh](https://github.com/powhapki/ha-se/blob/master/terraform-vault-cluster/config_vault_server.sh)

## Initialization and Unsealing of the Vault Server
### Initializing
After installing and configuring the Vault Server, you need to initialize the Vault Server.
Before proceding the CLI operations, you need to specify the VAULT_ADDR first.
<pre>
$ export VAULT_ADDR=`http://127.0.0.1:8200`
$ vault operator init
</pre>

The output will be like the followings.

<pre>
Unseal Key 1: xxxxxxx
Unseal Key 2: ytttttttt
Unseal Key 3: aaaaaaa
Unseal Key 4: ggggggggggg
Unseal Key 5: y33ddddddddd

Initial Root Token: absdfsdsdfsd
...
</pre>

### Unseal


*You need to save the Unseal Key and Initial Root Token safely for further usage.*


***
Without Consul Backend, you need to specify the file backend.

<pre>
storage "file" {
  path = "/mnt/vault/data"
}
</pre>
