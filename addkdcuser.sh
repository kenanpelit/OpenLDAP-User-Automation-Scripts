#!/bin/sh
# filename: addkdcuser.sh
CONFIG="/home/hdfs/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "$0 <username> <password>"
  exit 1
fi
USERNAME=$1
PASSWORD=$2
$KDCADDCMD -p $KDCADMPRINC -w $KDCADMPWD -q "addprinc -pw ${PASSWORD} ${USERNAME}" 
if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, principal=${USERNAME}"
fi