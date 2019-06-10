#!/bin/bash
STEP00=`sudo yum install unzip -y`
echo "Install Unzip"
sleep 1
echo $STEP00

CONSUL_VERSION="1.5.1"
STEP01=`curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip`
echo "Donwloading latest CONSUL"
echo $STEP01
echo "Finished"
sleep 1

echo "Unzip CONSUL"
STEP02=`unzip consul_${CONSUL_VERSION}_linux_amd64.zip`
echo $STEP02
echo `ls -al consul`
sleep 1
 
echo "Change the owner of consul to root"
STEP03=`sudo chown root:root consul`
echo $STEP03
sleep 1

echo "copy consul to /usr/local/bin"
STEP04=`sudo mv consul /usr/local/bin/`
echo $STEP04
sleep 1

echo "Verifying consul Version"
STEP05=`consul --version`
echo $STEP05
sleep 1

echo "Performming Vault autocomplete install"
STEP06=`consul -autocomplete-install && complete -C /usr/local/bin/consul consul`
echo $STEP06
sleep 1


echo "Create a unique, non-privileged system user to run Consul and create its data directory"
STEP07_1=`sudo useradd --system --home /etc/consul.d --shell /bin/false consul`
echo $STEP07_1
STEP07_2=`sudo mkdir --parents /opt/consul`
echo $STEP07_2
STEP07_3=`sudo chown --recursive consul:consul /opt/consul`
echo $STEP07_3
sleep 1

echo "Configure systemd"
echo "Step 1: Create a Consul Service file"
sudo touch /etc/systemd/system/consul.service
sudo cat << EOF > /etc/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
