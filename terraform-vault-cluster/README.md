# Provision the Vault Server
***
When you use userdata for AWS, you can refer [user_data_4_poc](https://github.com/powhapki/ha-se/blob/master/terraform-vault-cluster/user_data_4_poc) as a sample input.


## Procedure for Vault Server Install and configure.
Run each scripts with the following orders.
1. [inst_vault.sh](https://github.com/powhapki/ha-se/blob/master/terraform-vault-cluster/inst_vault.sh)
2. [configure_vault_server.sh](https://github.com/powhapki/ha-se/blob/master/terraform-vault-cluster/config_vault_server.sh)

## Start Vault
Enable and start Vault using the systemctl command responsible for controlling systemd managed services. Check the status of the vault service using systemctl.

<pre>
sudo systemctl enable vault
sudo systemctl start vault
sudo systemctl status vault
</pre>

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
*You need to save the Unseal Key and Initial Root Token safely for further usage.*


### Unseal
Vault initialized with 5 key shares and a key threshold of 3. Please securely distribute the key shares printed above. When the Vault is re-sealed, restarted, or stopped, you must supply at least 3 of these keys to unseal it before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 key to reconstruct the master key, Vault will remain permanently sealed!

Before proceding the CLI operations, you need to specify the ROOT_TOKEN.
<pre>
export ROOT_TOKEN='absdfsdsdfsd'
</pre>

<pre>
$ vault operator unseal ggggggggggg
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       f9608b16-e8d1-0ba5-6336-a37f0758ec86
Version            1.2.2+ent.hsm
HA Enabled         false
$ vault operator unseal y33ddddddddd
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       f9608b16-e8d1-0ba5-6336-a37f0758ec86
Version            1.2.2+ent.hsm
HA Enabled         false
$ vault operator unseal xxxxxxx
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    3
Unseal Nonce       f9608b16-e8d1-0ba5-6336-a37f0758ec86
Version            1.2.2+ent.hsm
HA Enabled         false
</pre>

## Time for using the Vault
Now, you can use the Vault Server for the POC.
Here're some useful links.

+ [learn.hashicorp.com/vault](http://learn.hashicorp.com/vault/)
+ [Vault Documentation](https://www.vaultproject.io/docs/)
+ [Vault API Documentation](https://www.vaultproject.io/api/)


***
Without a Consul Backend, you need to specify the file backend.

<pre>
storage "file" {
  path = "/mnt/vault/data"
}
</pre>
