#!/bin/bash
STEP00=`sudo apt install unzip -y`
echo "Install Unzip"
sleep 1
echo $STEP00

VAULT_VERSION="1.1.3"
STEP01=`curl --silent --remote-name https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip`
echo "Donwloading latest VAULT"
echo $STEP01
echo "Finished"
sleep 1

echo "Unzip Vault"
STEP02=`unzip vault_${VAULT_VERSION}_linux_amd64.zip`
echo $STEP02
echo `ls -al vault`
sleep 1
 
STEP03=`sudo chown root:root vault`
echo $STEP03
sleep 1

STEP04=`sudo mv vault /usr/local/bin/`
echo $STEP04
sleep 1

echo "Verifying Vault Version"
STEP05=`vault --version`
echo $STEP05
sleep 1

echo "Performming Vault autocomplete install"
STEP06=`vault -autocomplete-install`
echo $STEP06
sleep 1
complete -C /usr/local/bin/vault vault


echo "Give Vault the ability to use the mlock syscall without running the process as root"
sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault


echo "Create a unique, non-privileged system user to run Vault and create its data directory"
STEP07_1=`sudo useradd --system --home /etc/vault.d --shell /bin/false vault`
echo $STEP07_1
STEP07_2=`sudo mkdir --parents /var/run/vault`
echo $STEP07_2
STEP07_3=`sudo chown --recursive vault:vault /var/run/vault`
echo $STEP07_3
sleep 1


echo "Configure systemd"
echo "Step 1: Create a Vault Service file"
sudo touch /etc/systemd/system/vault.service
sudo cat << EOF > /etc/systemd/system/vault.service
### BEGIN INIT INFO
# Provides:          vault
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Vault server
# Description:       Vault secret management tool
### END INIT INFO

[Unit]
Description=Vault secret management tool
Requires=network-online.target
After=network-online.target

[Service]
User=vault
Group=vault
PIDFile=/var/run/vault/vault.pid
ExecStart=/usr/local/bin/vault server -config=/usr/local/etc/consul/vault_server.hcl -log-level=debug
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
RestartSec=42s
LimitMEMLOCK=infinity

[Install]
WantedBy=multi-user.target
EOF
