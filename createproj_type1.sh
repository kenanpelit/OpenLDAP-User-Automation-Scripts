#!/bin/sh
# filename: createproj_type1.sh
CONFIG="/home/hdfs/ldap/config"
. $CONFIG
if [[ ( -z $1 ) || ( -z $2 ) ]]; then
  echo "$0 <projectname> <hdfsquota>"
  exit 1
fi
#
PROJECT=$1
QUOTA=$2
DESCRIP="loader"
#
echo "+-------------------------------------------------------------------+"
echo "This script will "
echo "(1) Creating LDAP Group..."
echo "(2) Creating LDAP User..."
echo "(3) Creating Kerberos User..."
echo "(4) Creating HDFS Home Dir..."
echo "(5) Setting HDFS Home Dir's Quota..."
echo "(6) Creating Hive Upload Dir..."
echo "(7) Setting Hive Upload Dir's Quota..."
echo "(8) Setting Hive Upload Dir's ACL..."
echo "(9) Creating Hive DB, Role..."
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
echo "(4) Creating HDFS Home Dir..."
SVR=tf2p079
DIRNAME="/user/$PROJECT"
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;sh $SCRIPTDIR/mkhdfsdir.sh $DIRNAME $PROJECT" 2>/dev/null
echo "Listing HDFS Home Dir..."
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;hdfs dfs -ls -d $DIRNAME" 2>/dev/null
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "(5) Setting HDFS Home Dir's Quota..."
SVR=tf2p079
DIRNAME="/user/$PROJECT"
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;sh $SCRIPTDIR/sethdfsquota.sh $DIRNAME $QUOTA" 2>/dev/null
echo "Listing HDFS Home Dir's Quota..."
RET=`ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC;hdfs dfs -count -q $DIRNAME" 2>/dev/null`;echo $RET|cut -d' ' -f11,6,7
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "(6) Creating Hive Upload Dir..."
SVR=tf2p079
DIRNAME="/hive/${PROJECT}_upload"
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;sh $SCRIPTDIR/mkhdfsdir.sh $DIRNAME hive" 2>/dev/null
echo "Listing Hive Upload Dir..."
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;hdfs dfs -ls -d $DIRNAME" 2>/dev/null
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "(7) Setting Hive Upload Dir's Quota..."
SVR=tf2p079
DIRNAME="/hive/${PROJECT}_upload"
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;sh $SCRIPTDIR/sethdfsquota.sh $DIRNAME $QUOTA" 2>/dev/null
echo "Listing Hive Upload Dir's Quota..."
RET=`ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC;hdfs dfs -count -q $DIRNAME" 2>/dev/null`;echo $RET|cut -d' ' -f11,6,7
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "(8) Setting Hive Upload Dir's ACL..."
SVR=tf2p079
DIRNAME="/hive/${PROJECT}_upload"
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;sh $SCRIPTDIR/sethdfsacl.sh $DIRNAME 2>/dev/null default:group:$PROJECT:rwx,group:$PROJECT:rwx"
echo "Listing Hive Upload Dir's ACL..."
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;hdfs dfs -getfacl $DIRNAME" 2>/dev/null
echo "Press Any Key to Continue..."
stty_orig=`stty -g`
stty -echo
read USERPASS
stty $stty_orig
#
echo "+-------------------------------------------------------------------+"
echo "(9) Creating Hive DB, Role..."
SVR=tf2p079
JDBCURL="jdbc:hive2://tf2p077.cht.local:10000/default;principal=hive/tf2p077.cht.local@CHT.COM.TW"
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;sh $SCRIPTDIR/createdb.sh \"$JDBCURL\" $PROJECT" 2>/dev/null
echo "Listing Database $PROJECT..."
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;beeline --silent=true -u \"$JDBCURL\" -e \"describe database $PROJECT\"" 2>/dev/null
ROLENAME="${PROJECT}_user"
echo "Listing Role $ROLENAME..."
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;beeline --silent=true -u \"$JDBCURL\" -e \"show grant role $ROLENAME\"" 2>/dev/null
echo "Listing Group $PROJECT..."
ssh $SVR "echo $HDFSKDCPWD|kinit $HDFSKDCPRINC >/dev/null;beeline --silent=true -u \"$JDBCURL\" -e \"show role grant group $PROJECT\"" 2>/dev/null
#
echo "+-------------------------------------------------------------------+"
echo "All are done"
echo "+-------------------------------------------------------------------+"

#