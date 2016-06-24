#!/bin/sh
# filename: addldapgroup.sh
CONFIG="/home/hdfs/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "$0 <groupname> <description>"
exit 1
fi
GROUPNAME=$1
TYPE=$2
LDIFNAME=$TMP/grp_$GROUPNAME.ldif
LGID=`echo $[ 20000 + $[ RANDOM % 9999 ]]`
(
cat <<add-group
dn: cn=$GROUPNAME,$LDAPGROUPSUX
objectClass: posixGroup
description: $TYPE
gidNumber: $LGID
cn: $GROUPNAME
add-group
) > $LDIFNAME
$LDAPADDCMD -x -w $LDAPPASS -D "cn=root,$LDAPROOTSUX" -f $LDIFNAME
if [ $? -ne "0" ]; then
  echo "Failed"
  echo "Please review $LDIFNAME and add the account manually"
else
  echo "Successfully, gidNumber=$LGID"
fi