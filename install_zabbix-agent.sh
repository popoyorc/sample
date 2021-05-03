#!/bin/bash


PM=$(command -v yum || command -v apt)

if [[ "$PM" == "/usr/bin/apt"  ]]; then
	wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+$(lsb_release -sc)_all.deb
	dpkg -i zabbix-release_5.0-1+$(lsb_release -sc)_all.deb
	apt update
elif [[ "$PM" = "/usr/bin/yum" ]]; then
	rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/$(rpm -E %{rhel})/x86_64/zabbix-release-5.0-1.el$(rpm -E %{rhel}).noarch.rpm
	yum clean all
fi

$PM -y install zabbix-agent

cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=192.168.4.5
ServerActive=192.168.4.5
HostMetadataItem=system.uname
AllowRoot = 1
EnableRemoteCommands=1
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF

#sed --in-place=".OLD" -e 's/#.*$//' -e '/^$/d' -e '/Hostname/d' -e 's/Server=127.0.0.1/Server=zabbix/' -e 's/ServerActive=127.0.0.1/ServerActive=zabbix/' -e '5 a HostMetadataItem=system.uname' /etc/zabbix/zabbix_agentd.conf
systemctl enable zabbix-agent; systemctl restart zabbix-agent; systemctl status zabbix-agent
