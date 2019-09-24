Provision the Vault cluster

Without Consul Backend, you need to specify the file backend.

<pre>
storage "file" {
  path = "/mnt/vault/data"
}
</pre>
