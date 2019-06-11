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


sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault
sudo useradd --system --home /etc/vault.d --shell /bin/false vault
sudo touch /etc/systemd/system/vault.service

