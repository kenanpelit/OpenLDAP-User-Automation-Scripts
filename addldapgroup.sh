#!/bin/sh
# filename: addldapgroup.sh
CONFIG="/root/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "$0 <groupname> <type>, type = [1|2|3]"
exit 1
fi
GROUPNAME=$1
TYPE=$2
LDIFNAME=$TMP/grp_$GROUPNAME.ldif
LGID=`echo $[ 20000 + $[ RANDOM % 9999 ]]`
(
cat <<add-group
dn: cn=$GROUPNAME,ou=group,dc=chttl,dc=cht,dc=com,dc=tw
objectClass: posixGroup
description: type$TYPE
gidNumber: $LGID
cn: $GROUPNAME
add-group
) > $LDIFNAME
$LDAPADDCMD -x -w $LDAPPASS -D "cn=root,dc=chttl,dc=cht,dc=com,dc=tw" -f $LDIFNAME
if [ $? -ne "0" ]; then
 echo "Failed"
 echo "Please review $LDIFNAME and add the account manually"
else
 echo "Successfully, gidNumber=$LGID"
fi