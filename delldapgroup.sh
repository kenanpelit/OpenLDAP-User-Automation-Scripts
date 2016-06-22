#!/bin/sh
# filename: delldapgroup.sh
CONFIG="/root/ldap/config"

. $CONFIG

if [ -z $1 ];  then
  echo "$0 <groupname>"
  exit 1
fi

GROUPNAME=$1

$LDAPDELCMD -x -w $LDAPPASS -D "cn=root,dc=chttl,dc=cht,dc=com,dc=tw" "cn=$GROUPNAME,ou=group,dc=chttl,dc=cht,dc=com,dc=tw"

if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, cn=$GROUPNAME"
fi