#!/bin/sh
# filename: createproj_type3.sh
CONFIG="/home/hdfs/ldap/config"
. $CONFIG
if [[ ( -z $1 ) ]]; then
  echo "$0 <projectname>"
  exit 1
fi
#
PROJECT=$1
QUOTA=$2
DESCRIP="analysis"
#
echo "+-------------------------------------------------------------------+"
echo "This script will "
echo "(1) Creating LDAP Group..."
echo "(2) Creating LDAP User..."
echo "(3) Creating Kerberos User..."
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
# 
echo "+-------------------------------------------------------------------+"
echo "(1) Creating LDAP Group..."
SVR=tfxa008
RET=`ssh $SVR "sh $SCRIPTDIR/addldapgroup.sh $PROJECT $DESCRIP" 2>/dev/null`
GID=`echo $RET|cut -d ' ' -f6|cut -d '=' -f2`
echo "Project ${PROJECT} 's LDAP Group gidNumber=[${GID}]"
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "(2) Creating LDAP User..."
SVR=tfxa008
RET=`ssh $SVR "sh $SCRIPTDIR/addldapuser.sh $GID $PROJECT" 2>/dev/null`
UNUM=`echo $RET|cut -d ' ' -f7|cut -d '=' -f2`
echo "Project ${PROJECT} 's LDAP User uidNumber=[${UNUM}], pwd=[$UNUM]"
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "(3) Creating Kerberos User..."
RET=`sh $SCRIPTDIR/addkdcuser.sh $PROJECT $UNUM 2>/dev/null`
PRINC=`echo $RET|cut -d ' ' -f8|cut -d "\"" -f2`
echo "Project ${PROJECT} 's Kerberos principal=[${PRINC}], pwd=[$UNUM]"
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "All are done"
echo "+-------------------------------------------------------------------+"
