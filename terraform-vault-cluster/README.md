Provision the Vault cluster

Without Consul Backend, you need to specify the file backend.

storage "file" {
  path = "/mnt/vault/data"
}
