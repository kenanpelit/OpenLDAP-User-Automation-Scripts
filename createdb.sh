#!/bin/sh
# filename: createdb.sh
CONFIG="/root/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "$0 <jdbcurl> <groupname>"
  exit 1
fi
DBURL=$1
GROUPNAME=$2
DBNAME=$2
DIRNAME="hdfs://nameservice1/hive/${DBNAME}_upload"
ROLENAME="${DBNAME}_user"
beeline --silent=true -u "$DBURL" -e "create database $DBNAME;"
beeline --silent=true -u "$DBURL" -e "create role $ROLENAME;"
beeline --silent=true -u "$DBURL" -e "grant all on database $DBNAME to role $ROLENAME;"
beeline --silent=true -u "$DBURL" -e "grant all on URI '$DIRNAME' to role $ROLENAME;"
beeline --silent=true -u "$DBURL" -e "grant role $ROLENAME to group $GROUPNAME;"

if [ $? -ne "0" ]; then
  echo "Failed"
else
  echo "Successfully, DB is ${DBNAME}, Grant ROLE ${ROLENAME} to Group ${GROUPNAME}"
fi