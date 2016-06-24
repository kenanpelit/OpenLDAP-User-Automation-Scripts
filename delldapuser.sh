#!/bin/sh
# filename: delldapuser.sh
CONFIG="/home/hdfs/ldap/config"

. $CONFIG

if [ -z $1 ];  then
  echo "$0 <username>"
  exit 1
fi

USERNAME=$1

$LDAPDELCMD -x -w $LDAPPASS -D "cn=root,$LDAPROOTSUX" "uid=$USERNAME,$LDAPUSERSUX"

if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, uid=$USERNAME"
fi