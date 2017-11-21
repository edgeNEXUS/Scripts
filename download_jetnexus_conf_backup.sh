#!/bin/bash

#USAGE
####################
# Please pass arguments as given
# download_jetnexus_conf_backup.sh <IP_ADDRESS> <ALB_USERNAME> <ALB_PASSWORD>
# For example 
# download_jetnexus_conf_backup.sh 192.168.3.152 admin jetnexus
####################

ip=$1
user=$2
password=$3

if [ "$ip" == "" ] || [ "$user" == "" ] || [ "$password" == "" ]; then
	echo "Please pass all required arguments"
	echo ""
	echo "USAGE INSTRUCTIONS"
	echo "####################"
	echo ""
	echo "download_jetnexus_conf_backup.sh <IP_ADDRESS> <ALB_USERNAME> <ALB_PASSWORD>"
	exit 1
fi

datetime=`date '+%Y%m%d%H%M%S'`
back="backup/"
underscore="_"
conf=".conf"
filename=$back$ip$underscore$datetime$conf
echo $filename

#check if directory exists, otherwise create new
if [ ! -d "backup" ]; then
  mkdir backup
fi

guid=$(curl -s --connect-timeout 15 -k -d "{\"$user\":\"$password\"}" https://$ip/POST/32 | grep 'GUID' | sed -e 's/.*GUID":"//' -e 's/".*//') #'
err=$?
if [ "$err" == "0" ] && [ "$guid" != "" ]; then
	curl -s -k -H "Cookie: GUID=$guid;" https://$ip/GET/26?download=conf >> $filename 
	err2=$?
	if [ "$err2" == "0" ]; then
		echo "Configuration backup succesfully saved at "$filename
		exit 0
	else
		echo "Error while saving Configuration backup: "$err2
		echo ""
		echo "USAGE INSTRUCTIONS"
		echo "####################"
		echo ""
		echo "download_jetnexus_conf_backup.sh <IP_ADDRESS> <ALB_USERNAME> <ALB_PASSWORD>"
		exit 1
	fi
else
	echo "Error while login on server: "$err
	echo ""
	echo "USAGE INSTRUCTIONS"
	echo "####################"
	echo ""
	echo "download_jetnexus_conf_backup.sh <IP_ADDRESS> <ALB_USERNAME> <ALB_PASSWORD>"
	exit 1
fi	


