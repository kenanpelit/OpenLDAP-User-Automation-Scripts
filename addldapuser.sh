#!/bin/sh
# filename: addldapuser.sh
CONFIG="/root/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "addldapuser.sh <gidNumber> <username> "
  exit 1
fi
USERNAME=$1
LDIFNAME=$TMP/usr_$USERNAME.ldif
LGID=$2
LUID=`echo $[ 20000 + $[ RANDOM % 9999 ]]`
PASSWORD=`$SLAPPASSWORD -h "{crypt}" -s $LUID`
(
cat <<add-user
dn: uid=$USERNAME,ou=people,dc=chttl,dc=cht,dc=com,dc=tw
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
homeDirectory: /home/$USERNAME
loginShell: /bin/bash
gidNumber: $LGID
uidNumber: $LUID
uid: $USERNAME
cn: $USERNAME
sn: $USERNAME
userPassword: $PASSWORD
mail: $USERNAME@cht.com.tw
add-user
) > $LDIFNAME
$LDAPADDCMD -x -w $LDAPPASS -D "cn=root,dc=chttl,dc=cht,dc=com,dc=tw" -f $LDIFNAME
if [ $? -ne "0" ]; then
  echo "Failed"
  echo "Please review $LDIFNAME and add the account manually"
else
  echo "Successfully, gidNumber=$LGID, uidNumber=$LUID"
fi