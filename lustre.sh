#!/bin/bash

echo "=================="$(hostname)"==================="
mkdir -p /etc/zabbix/scripts/agentd/lustre/
cat <<EOF > /etc/zabbix/scripts/agentd/lustre/lustre.sh
#!/bin/bash
OUT=`lctl ping $(ifconfig bond0 | grep inet | awk '{print $2}' | cut -f2 -d:) 2>/dev/null | grep -e "12345-" | wc -l`
if [[ ${OUT} == '2' ]]; then
        echo "0"
else
        echo "1"
fi
EOF
chmod +x /etc/zabbix/scripts/agentd/lustre/lustre.sh
cat "UserParameter=lustre.ping,/etc/zabbix/scripts/agentd/lustre/lustre.sh" > /etc/zabbix/zabbix_agent.d/lustre.conf
systemctl restart zabbix-agent
