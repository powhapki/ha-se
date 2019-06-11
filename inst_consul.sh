#!/bin/bash
STEP00=`sudo apt install unzip -y`
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
STEP06_1=`consul -autocomplete-install`
echo $STEP06_1
STEP06_2=`complete -C /usr/local/bin/consul consul`
echo $STEP06_2
sleep 1


echo "Create a unique, non-privileged system user to run Consul and create its data directory"
STEP07_1=`sudo useradd --system --home /usr/local/etc/consul --shell /bin/false consul`
echo $STEP07_1
STEP07_2=`sudo mkdir --parents /var/run/consul`
echo $STEP07_2
STEP07_3=`sudo chown --recursive consul:consul /var/run/consul`
echo $STEP07_3
sleep 1


echo "Configure systemd: Create a Consul Service file"
sudo touch /etc/systemd/system/consul.service
sudo cat << EOF > /etc/systemd/system/consul.service
### BEGIN INIT INFO
# Provides:          consul
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Consul agent
# Description:       Consul service discovery framework
### END INIT INFO

[Unit]
Description=Consul server agent
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/usr/local/etc/consul/server_agent.json

[Service]
User=consul
Group=consul
PIDFile=/var/run/consul/consul.pid
PermissionsStartOnly=true
ExecStart=/usr/local/bin/consul agent -config-file=/usr/local/etc/consul/server_agent.json -pid-file=/var/run/consul/consul.pid -disable-keyring-file
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
EOF
