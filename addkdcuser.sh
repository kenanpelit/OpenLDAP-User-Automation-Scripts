#!/bin/sh
# filename: addkdcuser.sh
CONFIG="/root/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "addkdcuser.sh <username> <password>"
  exit 1
fi
USERNAME=$1
PASSWORD=$2
$KDCADDCMD -q "addprinc -pw ${PASSWORD} ${USERNAME}" 
if [ $? -ne "0" ]; then
  echo "Failed"
  echo "Please review $LDIFNAME and add the account manually"
else
  echo "Successfully, gidNumber=$LGID, uidNumber=$LUID"
fi