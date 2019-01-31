#!/bin/bash

function usage() {
	cat <<EOF
Usage: $(basename $0)	[-a activation_key] [-l ip_file]*
EOF
	exit 1
}


while getopts ':a:l:' o; do
	case "${o}" in
		a)
			a=${OPTARG}
			;;
		l)
			l=${OPTARG}
			;;
		*)
			usage
			;;
	esac
done

shift $((OPTIND-1))

if [ ! -f "${l}" ]; then
	usage
fi

while read p; do
#	ssh -tt narmis@$p <<EOF
#echo "${l}"
#exit
#EOF
	
	ssh -tt "$p" <<EOF
sudo subscription-manager clean
sudo rpm -Uvh http://rhel-satelite.dict.gov.ph/pub/katello-ca-consumer-latest.noarch.rpm
sudo yum install -y katello-agent
sudo sucscription-manager repos --enable=rhel-\*-satellite-tools-\*-rpms

exit
EOF

if [ ! -z "${a}"]; then
	ssh -tt "$p" << EOF
subscription-manager register --org="Department_of_Information_and_Communication_Technology" --activationkey="${a}"

exit
EOF
fi



done < ${l}
