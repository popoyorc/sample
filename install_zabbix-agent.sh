#!/bin/bash

HOST=192.168.4.5
PORT=10051

if nc -zw1 $HOST $PORT; then
	PM=$(command -v yum || command -v apt)

	if [[ "$PM" = *"apt"*  ]]; then
		wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+$(lsb_release -sc)_all.deb
		dpkg -i zabbix-release_5.0-1+$(lsb_release -sc)_all.deb
	elif [[ "$PM" = *"yum"* ]]; then
		yum install -y https://repo.zabbix.com/zabbix/5.0/rhel/$(rpm -E %{rhel})/x86_64/zabbix-release-5.0-1.el$(rpm -E %{rhel}).noarch.rpm

	fi

	$PM -y update
	$PM -y install zabbix-agent

cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=192.168.4.5
ServerActive=192.168.4.5
HostMetadataItem=system.uname
EnableRemoteCommands=1
AllowRoot = 1
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF

systemctl enable zabbix-agent; systemctl restart zabbix-agent; systemctl status zabbix-agent

else
	echo "Connection KO"
fi

#sed --in-place=".OLD" -e 's/#.*$//' -e '/^$/d' -e '/Hostname/d' -e 's/Server=127.0.0.1/Server=zabbix/' -e 's/ServerActive=127.0.0.1/ServerActive=zabbix/' -e '5 a HostMetadataItem=system.uname' /etc/zabbix/zabbix_agentd.conf

