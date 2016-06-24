#!/bin/sh
# filename: sethdfsquota.sh
CONFIG="/home/hdfs/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "$0 <dirname> <quota>"
  exit 1
fi
DIRNAME=$1
QUOTA=$2
hdfs dfsadmin -setSpaceQuota $QUOTA ${DIRNAME}
if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, ${DIRNAME} 's quota is ${QUOTA}"
fi