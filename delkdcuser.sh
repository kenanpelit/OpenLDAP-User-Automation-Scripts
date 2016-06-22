#!/bin/sh
# filename: delkdcuser.sh
CONFIG="/root/ldap/config"
. $CONFIG
if [[ ( -z $1 ) ]]; then
  echo "$0 <username>"
  exit 1
fi
USERNAME=$1
$KDCADDCMD -q "delprinc -force ${USERNAME}" 
if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, principal=${USERNAME}"
fi