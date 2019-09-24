#!/bin/bash
STEP00=`sudo apt install unzip -y`
echo "Install Unzip"
sleep 1
echo $STEP00

STEP01=`curl --silent --remote-name https://s3-us-west-2.amazonaws.com/hc-enterprise-binaries/vault/ent.hsm/1.2.2/vault-enterprise_1.2.2%2Bent.hsm_linux_amd64.zip`
echo "Donwloading latest VAULT"
echo $STEP01
echo "Finished"
sleep 10

echo "Unzip Vault"
STEP02=`unzip vault-enterprise_1.2.2%2Bent.hsm_linux_amd64.zip`
echo $STEP02
echo `ls -al vault`
sleep 10
 
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
complete -C /usr/local/bin/vault vault
echo $STEP06
sleep 10


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
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/vault.hcl
StartLimitIntervalSec=60
StartLimitBurst=3

[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault_server.hcl -log-level=debug
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitInterval=60
StartLimitIntervalSec=60
StartLimitBurst=3
LimitNOFILE=65536
LimitMEMLOCK=infinity

[Install]
WantedBy=multi-user.target
EOF
