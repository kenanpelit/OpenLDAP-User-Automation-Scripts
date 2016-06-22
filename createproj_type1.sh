#!/bin/sh
# filename: createproj_type1.sh
CONFIG="/root/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "$0 <projectname> <hdfsquota>"
  exit 1
fi
#
PROJECT=$1
QUOTA=$2
DESCRIP="type1"
# 
echo "+-------------------------------------------------------------------+"
echo "Creating LDAP Group..."
RET=`ssh kdc "sh /root/ldap/addldapgroup.sh $PROJECT $DESCRIP"`
GID=`echo $RET|cut -d ' ' -f6|cut -d '=' -f2`
echo "Project ${PROJECT} 's LDAP Group gidNumber=[${GID}]"
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "Creating LDAP User..."
RET=`ssh kdc "sh /root/ldap/addldapuser.sh $GID $PROJECT"`
UNUM=`echo $RET|cut -d ' ' -f7|cut -d '=' -f2`
echo "Project ${PROJECT} 's LDAP User uidNumber=[${UNUM}], pwd=[$UNUM]"
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "Creating Kerberos User..."
RET=`ssh kdc "sh /root/ldap/addkdcuser.sh $PROJECT $UNUM"`;
PRINC=`echo $RET|cut -d ' ' -f8|cut -d "\"" -f2`
echo "Project ${PROJECT} 's Kerberos principal=[${PRINC}], pwd=[$UNUM]"
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "Creating HDFS Home Dir..."
DIRNAME="/user/$PROJECT"
ssh master1 "echo hdfs|kinit hdfs/test >/dev/null;sh /root/ldap/mkhdfsdir.sh $DIRNAME $PROJECT"
echo "Listing HDFS Home Dir..."
ssh master1 "echo hdfs|kinit hdfs/test >/dev/null;hdfs dfs -ls -d $DIRNAME"
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "Setting HDFS Home Dir's Quota..."
DIRNAME="/user/$PROJECT"
ssh master1 "echo hdfs|kinit hdfs/test >/dev/null;sh /root/ldap/sethdfsquota.sh $DIRNAME $QUOTA"
echo "Listing HDFS Home Dir's Quota..."
RET=`ssh master1 "echo hdfs|kinit hdfs/test;hdfs dfs -count -q $DIRNAME"`;echo $RET|cut -d' ' -f11,6,7
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "Creating Hive Upload Dir..."
DIRNAME="/hive/${PROJECT}_upload"
ssh master1 "echo hdfs|kinit hdfs/test >/dev/null;sh /root/ldap/mkhdfsdir.sh $DIRNAME hive"
echo "Listing Hive Upload Dir..."
ssh master1 "echo hdfs|kinit hdfs/test >/dev/null;hdfs dfs -ls -d $DIRNAME"
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "Setting Hive Upload Dir's Quota..."
DIRNAME="/hive/${PROJECT}_upload"
ssh master1 "echo hdfs|kinit hdfs/test >/dev/null;sh /root/ldap/sethdfsquota.sh $DIRNAME $QUOTA"
echo "Listing Hive Upload Dir's Quota..."
RET=`ssh master1 "echo hdfs|kinit hdfs/test;hdfs dfs -count -q $DIRNAME"`;echo $RET|cut -d' ' -f11,6,7
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "Setting Hive Upload Dir's ACL..."
DIRNAME="/hive/${PROJECT}_upload"
ssh master1 "echo hdfs|kinit hdfs/test >/dev/null;sh /root/ldap/sethdfsacl.sh $DIRNAME default:group:$PROJECT:rwx,group:$PROJECT:rwx"
echo "Listing Hive Upload Dir's ACL..."
ssh master1 "echo hdfs|kinit hdfs/test >/dev/null;hdfs dfs -getfacl $DIRNAME"
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "Creating Hive DB, Role..."
ssh master4 "echo hdfs|kinit hdfs/test >/dev/null;sh /root/ldap/createdb.sh \"jdbc:hive2://master4:10000/default;principal=hive/cluster5node5.cht.local@CHT.COM.TW\" $PROJECT"
echo "Listing Database $PROJECT..."
ssh master4 "echo hdfs|kinit hdfs/test >/dev/null;beeline --silent=true -u \"jdbc:hive2://master4:10000/default;principal=hive/cluster5node5.cht.local@CHT.COM.TW\" -e \"describe database $PROJECT\""
ROLENAME="${PROJECT}_user"
echo "Listing Role $ROLENAME..."
ssh master4 "echo hdfs|kinit hdfs/test >/dev/null;beeline --silent=true -u \"jdbc:hive2://master4:10000/default;principal=hive/cluster5node5.cht.local@CHT.COM.TW\" -e \"show grant role $ROLENAME\""
echo "Listing Group $PROJECT..."
ssh master4 "echo hdfs|kinit hdfs/test >/dev/null;beeline --silent=true -u \"jdbc:hive2://master4:10000/default;principal=hive/cluster5node5.cht.local@CHT.COM.TW\" -e \"show role grant group $PROJECT\""
echo "+-------------------------------------------------------------------+"
#