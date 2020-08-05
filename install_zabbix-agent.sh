yum install -y http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm && yum install -y zabbix-agent
cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=192.168.2.20
ServerActive=192.168.2.20
HostMetadataItem=system.uname
AllowRoot = 1
EnableRemoteCommands=1
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF
#sed --in-place=".OLD" -e 's/#.*$//' -e '/^$/d' -e '/Hostname/d' -e 's/Server=127.0.0.1/Server=zabbix/' -e 's/ServerActive=127.0.0.1/ServerActive=zabbix/' -e '5 a HostMetadataItem=system.uname' /etc/zabbix/zabbix_agentd.conf
systemctl enable zabbix-agent; systemctl restart zabbix-agent; systemctl status zabbix-agent
