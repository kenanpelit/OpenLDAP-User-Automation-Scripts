#!/bin/sh
# filename: mkhdfsdir.sh
CONFIG="/root/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "$0 <dirname> <ownername>"
  exit 1
fi
DIRNAME=$1
OWNERNAME=$2
hdfs dfs -mkdir -p "${DIRNAME}";hdfs dfs -chown -R "${OWNERNAME}:${OWNERNAME}" "${DIRNAME}"
if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, ${DIRNAME} 's owner is ${OWNERNAME}"
fi