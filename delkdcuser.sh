#!/bin/sh
# filename: delkdcuser.sh
CONFIG="/home/hdfs/ldap/config"
. $CONFIG
if [[ ( -z $1 ) ]]; then
  echo "$0 <username>"
  exit 1
fi
USERNAME=$1
$KDCADDCMD -p $KDCADMPRINC -w $KDCADMPWD -q "delprinc -force ${USERNAME}" 
if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, principal=${USERNAME}"
fi