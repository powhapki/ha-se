              #!/bin/bash
              VAULT_VERSION="1.1.3"
              curl --silent --remote-name https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
              unzip vault_${VAULT_VERSION}_linux_amd64.zip
              sudo chown root:root vault
              sudo mv vault /usr/local/bin/
              vault --version
              vault -autocomplete-install
              complete -C /usr/local/bin/vault vault
              sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault
              sudo useradd --system --home /etc/vault.d --shell /bin/false vault
              sudo touch /etc/systemd/system/vault.service
