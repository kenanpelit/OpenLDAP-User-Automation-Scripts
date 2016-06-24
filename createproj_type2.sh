PROJECT=loader_modap2;DIRNAME=/user/$PROJECT;ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/mkhdfsdir.sh $DIRNAME $PROJECT"
PROJECT=loader_modap2;DIRNAME=/user/$PROJECT;ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;hdfs dfs -ls -d $DIRNAME"
PROJECT=loader_modap2;DIRNAME=/user/$PROJECT;QUOTA=1t;ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/sethdfsquota.sh $DIRNAME $QUOTA"
PROJECT=loader_modap2;DIRNAME=/user/$PROJECT;RET=`ssh tf2p079 "echo hdfs|kinit hdfs/up;hdfs dfs -count -q $DIRNAME"`;echo $RET|cut -d' ' -f11,6,7

PROJECT=loader_modap2;DIRNAME="/hive/${PROJECT}_upload";ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/mkhdfsdir.sh $DIRNAME hive"
PROJECT=loader_modap2;DIRNAME="/hive/${PROJECT}_upload";ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;hdfs dfs -ls -d $DIRNAME"
PROJECT=loader_modap2;DIRNAME="/hive/${PROJECT}_upload";QUOTA=1t;ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/sethdfsquota.sh $DIRNAME $QUOTA"
PROJECT=loader_modap2;DIRNAME="/hive/${PROJECT}_upload";RET=`ssh tf2p079 "echo hdfs|kinit hdfs/up;hdfs dfs -count -q $DIRNAME"`;echo $RET|cut -d' ' -f11,6,7

PROJECT=loader_modap2;DIRNAME="/hive/${PROJECT}_upload";ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/sethdfsacl.sh $DIRNAME default:group:$PROJECT:rwx,group:$PROJECT:rwx"
PROJECT=loader_modap2;DIRNAME="/hive/${PROJECT}_upload";ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;hdfs dfs -getfacl $DIRNAME"

PROJECT=loader_modap2;ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/createdb.sh \"jdbc:hive2://tf2p077.cht.local:10000/default;principal=hive/tf2p077.cht.local@CHT.COM.TW\" $PROJECT"
PROJECT=loader_modap2;ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;beeline --silent=true -u       \"jdbc:hive2://tf2p077.cht.local:10000/default;principal=hive/tf2p077.cht.local@CHT.COM.TW\" -e \"describe database $PROJECT\""
PROJECT=loader_modap2;ROLENAME="${PROJECT}_user";ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;beeline --silent=true -u       \"jdbc:hive2://tf2p077.cht.local:10000/default;principal=hive/tf2p077.cht.local@CHT.COM.TW\" -e \"show grant role $ROLENAME\""
PROJECT=loader_modap2;ssh tf2p079 "echo hdfs|kinit hdfs/up >/dev/null;beeline --silent=true -u       \"jdbc:hive2://tf2p077.cht.local:10000/default;principal=hive/tf2p077.cht.local@CHT.COM.TW\" -e \"show role grant group $PROJECT\""



PROJECT=unloader_modap2;DESCRIP=unloader;ssh tfxa008 "sh /home/hdfs/ldap/addldapgroup.sh $PROJECT $DESCRIP"
PROJECT=unloader_modap2;LDAPGROUPSUX="ou=group,dc=cht,dc=local";ssh tfxa008 "ldapsearch -x -b \"cn=$PROJECT,$LDAPGROUPSUX\" \"objectclass=*\""

PROJECT=unloader_modap2;GID=20479;ssh tfxa008 "sh /home/hdfs/ldap/addldapuser.sh $GID $PROJECT"
PROJECT=unloader_modap2;LDAPUSERSUX="ou=People,dc=cht,dc=local";ssh tfxa008 "ldapsearch -x -b \"uid=$PROJECT,$LDAPUSERSUX\" \"objectclass=*\""

PROJECT=unloader_modap2;UNUM=25789;sh /home/hdfs/ldap/addkdcuser.sh $PROJECT $UNUM
PROJECT=unloader_modap2;kadmin -p hdfs/admin -w mp62j0 -q "listprincs $PROJECT@CHT.COM.TW"



PROJECT=modap2;DESCRIP=analysis;SVR=tfxa008;RET=`ssh $SVR "sh /home/hdfs/ldap/addldapgroup.sh $PROJECT $DESCRIP"`;echo "[$RET]"
PROJECT=modap2;SVR=tfxa008;LDAPGROUPSUX="ou=group,dc=cht,dc=local" ;ssh $SVR "ldapsearch -x -b \"cn=$PROJECT,$LDAPGROUPSUX\" \"objectclass=*\""

PROJECT=modap2;GID=20479;SVR=tfxa008;RET=`ssh $SVR "sh /home/hdfs/ldap/addldapuser.sh $GID $PROJECT"`;echo "[$RET]"
PROJECT=modap2;SVR=tfxa008;LDAPUSERSUX="ou=People,dc=cht,dc=local" ;ssh $SVR "ldapsearch -x -b \"uid=$PROJECT,$LDAPUSERSUX\""

PROJECT=modap2;UNUM=25789;SVR=tfxa008;RET=`ssh $SVR "sh /home/hdfs/ldap/addkdcuser.sh $PROJECT $UNUM"`;echo "[$RET]"
PROJECT=modap2;kadmin -p hdfs/admin -w mp62j0 -q "listprincs $PROJECT@CHT.COM.TW"

PROJECT=modap2;SVR=tf2p079;DIRNAME=/user/$PROJECT;ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/mkhdfsdir.sh $DIRNAME $PROJECT"
PROJECT=modap2;SVR=tf2p079;DIRNAME=/user/$PROJECT;RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;hdfs dfs -ls -d $DIRNAME"`;echo "[$RET]"

PROJECT=modap2;SVR=tf2p079;DIRNAME=/user/$PROJECT;QUOTA=1t;RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/sethdfsquota.sh $DIRNAME $QUOTA"`;echo "[$RET]"
PROJECT=modap2;SVR=tf2p079;DIRNAME=/user/$PROJECT;RET=`ssh $SVR "echo hdfs|kinit hdfs/up;hdfs dfs -count -q $DIRNAME" 2>/dev/null`;echo $RET|cut -d' ' -f11,6,7

PROJECT=modap2;SVR=tf2p079;DIRNAME="/hive/${PROJECT}_upload";RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/mkhdfsdir.sh $DIRNAME hive" 2>/dev/null`;echo "[$RET]"
PROJECT=modap2;SVR=tf2p079;DIRNAME="/hive/${PROJECT}_upload";RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;hdfs dfs -ls -d $DIRNAME" 2>/dev/null`;echo "[$RET]"

PROJECT=modap2;SVR=tf2p079;DIRNAME="/hive/${PROJECT}_upload";QUOTA=1t;RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/sethdfsquota.sh $DIRNAME $QUOTA" 2>/dev/null`;echo "[$RET]"
PROJECT=modap2;SVR=tf2p079;DIRNAME="/hive/${PROJECT}_upload";RET=`ssh $SVR "echo hdfs|kinit hdfs/up;hdfs dfs -count -q $DIRNAME" 2>/dev/null`;echo $RET|cut -d' ' -f11,6,7

PROJECT=modap2;SVR=tf2p079;DIRNAME="/hive/${PROJECT}_upload";RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/sethdfsacl.sh $DIRNAME default:group:$PROJECT:rwx,group:$PROJECT:rwx" 2>/dev/null`;echo "[$RET]"
PROJECT=modap2;SVR=tf2p079;DIRNAME="/hive/${PROJECT}_upload";RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;hdfs dfs -getfacl $DIRNAME" 2>/dev/null`;echo "[$RET]"

PROJECT=modap2;SVR=tf2p079;JDBCURL="jdbc:hive2://tf2p077.cht.local:10000/default;principal=hive/tf2p077.cht.local@CHT.COM.TW";RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;sh /home/hdfs/ldap/createdb.sh \"$JDBCURL\" $PROJECT" 2>/dev/null`;echo "[$RET]"
PROJECT=modap2;SVR=tf2p079;JDBCURL="jdbc:hive2://tf2p077.cht.local:10000/default;principal=hive/tf2p077.cht.local@CHT.COM.TW";RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;beeline --silent=true -u \"$JDBCURL\" -e \"describe database $PROJECT\"" 2>/dev/null`;echo "[$RET]"
PROJECT=modap2;SVR=tf2p079;JDBCURL="jdbc:hive2://tf2p077.cht.local:10000/default;principal=hive/tf2p077.cht.local@CHT.COM.TW";ROLENAME="${PROJECT}_user";RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;beeline --silent=true -u \"$JDBCURL\" -e \" show grant role $ROLENAME\"" 2>/dev/null`;echo "[$RET]"
PROJECT=modap2;SVR=tf2p079;JDBCURL="jdbc:hive2://tf2p077.cht.local:10000/default;principal=hive/tf2p077.cht.local@CHT.COM.TW";RET=`ssh $SVR "echo hdfs|kinit hdfs/up >/dev/null;beeline --silent=true -u \"$JDBCURL\" -e \"show role grant group $PROJECT\"" 2>/dev/null`;echo "[$RET]"


