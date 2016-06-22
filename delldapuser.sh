#!/bin/sh
# filename: delldapuser.sh
CONFIG="/root/ldap/config"

. $CONFIG

if [ -z $1 ];  then
  echo "$0 <username>"
  exit 1
fi

USERNAME=$1

$LDAPDELCMD -x -w $LDAPPASS -D "cn=root,dc=chttl,dc=cht,dc=com,dc=tw" "uid=$USERNAME,ou=people,dc=chttl,dc=cht,dc=com,dc=tw"

if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, uid=$USERNAME"
fi