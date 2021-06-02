#!/bin/bash

for d in /home/*/ /root/;do
	if [[ -f "$d.ssh/authorized_keys" ]]
	then
		cat $d.ssh/authorized_keys | grep "ssh-rsa" | awk '{print $2, $3}'
	fi
done
