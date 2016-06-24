#!/bin/sh
# filename: delldapgroup.sh
CONFIG="/home/hdfs/ldap/config"

. $CONFIG

if [ -z $1 ];  then
  echo "$0 <groupname>"
  exit 1
fi

GROUPNAME=$1

$LDAPDELCMD -x -w $LDAPPASS -D "cn=root,$LDAPROOTSUX" "cn=$GROUPNAME,$LDAPGROUPSUX"

if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, cn=$GROUPNAME"
fi