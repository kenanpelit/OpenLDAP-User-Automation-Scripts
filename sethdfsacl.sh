#!/bin/sh
# filename: sethdfsacl.sh
CONFIG="/root/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "$0 <dirname> <acl>"
  exit 1
fi
DIRNAME=$1
ACL=$2
hdfs dfs -setfacl -m $ACL $DIRNAME
if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, ${DIRNAME} 's acl is ${ACL}"
fi