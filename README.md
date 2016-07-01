These are scripts I used to add and delete OpenLDAP/Kerberos accounts. Not for anything beyond causal use. :)


## addldapgroup.sh

add the ldap group

#### Usage: 


`addldapuser.sh <groupname> <description>`
```
<groupname>: the ldap cn of group
<grouptype>: the ldap description of group
```

#### Example:

```
[root@kdc ldap]# sh addldapgroup.sh test06221700 type1
adding new entry "cn=test06221700,ou=group,dc=yyy,dc=xxx,dc=com,dc=tw"

Successfully, gidNumber=28565

[root@kdc ldap]# cat grp_test06221700.ldif
dn: cn=test06221700,ou=group,dc=yyy,dc=xxx,dc=com,dc=tw
objectClass: posixGroup
description: type1
gidNumber: 28565
cn: test06221700

[root@kdc ldap]# ldapsearch -x -b "cn=test06221700,ou=group,dc=yy,dc=xx,dc=com,dc=tw" 'objectclass=*'
# extended LDIF
#
# LDAPv3
# base <cn=test06221700,ou=group,dc=yyy,dc=xxx,dc=com,dc=tw> with scope subtree
# filter: objectclass=*
# requesting: ALL
#

# test06221700, group, yyy.xxx.com.tw
dn: cn=test06221700,ou=group,dc=yyy,dc=xxx,dc=com,dc=tw
objectClass: posixGroup
description: type1
gidNumber: 28565
cn: test06221700

# search result
search: 2
result: 0 Success

# numResponses: 2
# numEntries: 1
```

## addldapuser.sh

adds the ldap user. the ldap password is the uidNumber of user

#### Usage: 

`addldapuser.sh <gidNumber> <username>`

```
<gidNumber>: the ldap gidNumber of user 
<username>: the ldap uid of user
```

#### Example:

```
[root@kdc ldap]# sh addldapuser.sh 28565 test06221700
adding new entry "uid=test06221700,ou=people,dc=yyy,dc=xxx,dc=com,dc=tw"

Successfully, gidNumber=28565, uidNumber=20857

[root@kdc ldap]# cat usr_test06221700.ldif
dn: uid=test06221700,ou=people,dc=yyy,dc=xxx,dc=com,dc=tw
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
homeDirectory: /home/test06221700
loginShell: /bin/bash
gidNumber: 28565
uidNumber: 20857
uid: test06221700
cn: test06221700
sn: test06221700
userPassword: {CRYPT}Pwrd1bD5eCQUo
mail: test06221700@xxx.com.tw

[root@kdc ldap]# ldapsearch -x -b 'uid=test06221700,ou=people,dc=yyy,dc=xxx,dc=com,dc=tw' 'objectclass=*'
# extended LDIF
#
# LDAPv3
# base <uid=test06221700,ou=people,dc=yyy,dc=xxx,dc=com,dc=tw> with scope subtree
# filter: objectclass=*
# requesting: ALL
#

# test06221700, people, yyy.xxx.com.tw
dn: uid=test06221700,ou=people,dc=yyy,dc=xxx,dc=com,dc=tw
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
homeDirectory: /home/test06221700
loginShell: /bin/bash
gidNumber: 28565
uidNumber: 20857
uid: test06221700
cn: test06221700
sn: test06221700
userPassword:: e0NSWVBUfVB3cmQxYkQ1ZUNRVW8=
mail: test06221700@xxx.com.tw

# search result
search: 2
result: 0 Success

# numResponses: 2
# numEntries: 1
```


## addkdcuser.sh

adds the kerberos user

#### Usage: 

`addkdcuser.sh <username> <password>`

```
<username>: the kerberos principal of user
<password>: the kerberos password of user
```

#### Example:

```
[root@kdc ldap]# sh addkdcuser.sh test06221700 20857
Authenticating as principal root/admin@xxx.COM.TW with password.
WARNING: no policy specified for test06221700@xxx.COM.TW; defaulting to no policy
Principal "test06221700@xxx.COM.TW" created.
Successfully, principal=test06221700

[root@kdc ldap]# kadmin.local -q "listprincs test06221700*"
Authenticating as principal root/admin@xxx.COM.TW with password.
test06221700@xxx.COM.TW
```

## mkhdfsdir.sh

create hdfs directory

#### Usage: 

`mkhdfsdir.sh <dirname> <ownername>`

```
<dirname>: the directory name
<ownername>: the owner of directory

```

#### Example:

```
[root@cluster5node5 ldap]# echo hdfs|kinit hdfs/test >/dev/null;sh mkhdfsdir.sh /user/test06221700 test06221700
Successfully, /user/test06221700 's owner is test06221700

[root@master1 ldap]# echo hdfs|kinit hdfs/test >/dev/null;hdfs dfs -ls -d /user/test06221700
drwxrwx---   - test06221700 test06221700          0 2016-06-22 17:39 /user/test06221700
```

## sethdfsquota.sh

set the quota of hdfs directory

#### Usage: 

`sethdfsquota.sh <dirname> <quota>`

```
<dirname>: the directory name
<quota>: the quota of directory

```

#### Example:

```
[root@cluster5node5 ldap]# echo hdfs|kinit hdfs/test >/dev/null;sh sethdfsquota.sh /user/test06221700 1t
Successfully, /user/test06221700 's quota is 1t

[root@cluster5node5 ldap]# echo hdfs|kinit hdfs/test >/dev/null;hdfs dfs -count -q /user/test06221700
        none             inf   1099511627776   1099511627776            1            0                  0 /user/test06221700
```

## sethdfsacl.sh

set the acl of hdfs directory

#### Usage: 

`sethdfsacl.sh <dirname> <acl>`

```
<dirname>: the directory name
<acl>: the acl of directory

```

#### Example:

```
[root@cluster5node5 ldap]# echo hdfs|kinit hdfs/test >/dev/null;sh sethdfsacl.sh /user/test06221700 default:group:test06221700:rwx,group:test06221700:rwx
Successfully, /user/test06221700 's acl is default:group:test06221700:rwx,group:test06221700:rwx

[root@cluster5node5 ldap]# echo hdfs|kinit hdfs/test >/dev/null;hdfs dfs -getfacl /user/test06221700
# file: /user/test06221700
# owner: test06221700
# group: test06221700
user::rwx
group::rwx
group:test06221700:rwx
mask::rwx
other::---
default:user::rwx
default:group::rwx
default:group:test06221700:rwx
default:mask::rwx
default:other::---
```

## createdb.sh

create hive database, role, grant all privileges to role, and grant role to group

#### Usage: 

`createdb.sh <jdbcurl> <groupname>`

```
<jdbcurl>: the kerberos-based jdbc connection string
<groupname>: the db name, role name prefix, and the group name of permission granted

```

#### Example:

```
[root@cluster5node5 ldap]# echo hdfs|kinit hdfs/test >/dev/null;sh /root/ldap/createdb.sh "jdbc:hive2://master4:10000/default;principal=hive/cluster5node5.xxx.local@xxx.COM.TW" test06221700
Successfully, DB is test06221700, Grant ROLE test06221700_user to Group test06221700

[root@cluster5node5 ldap]# echo hdfs|kinit hdfs/test >/dev/null;beeline --silent=true -u "jdbc:hive2://master4:10000/default;principal=hive/cluster5node5.xxx.local@xxx.COM.TW" -e "describe database test06221700"
+---------------+----------+----------------------------------------------------------+-------------+-------------+-------------+--+
|    db_name    | comment  |                         location                         | owner_name  | owner_type  | parameters  |
+---------------+----------+----------------------------------------------------------+-------------+-------------+-------------+--+
| test06221700  |          | hdfs://nameservice1/user/hive/warehouse/test06221700.db  | hive        | USER        |             |
+---------------+----------+----------------------------------------------------------+-------------+-------------+-------------+--+

[root@cluster5node5 ~]# echo hdfs|kinit hdfs/test >/dev/null;beeline --silent=true -u "jdbc:hive2://master4:10000/default;principal=hive/cluster5node5.xxx.local@xxx.COM.TW" -e "show grant role test06221700_user"
+-----------------------------------------------+--------+------------+---------+--------------------+-----------------+------------+---------------+-------------------+----------+--+
|                   database                    | table  | partition  | column  |   principal_name   | principal_type  | privilege  | grant_option  |    grant_time     | grantor  |
+-----------------------------------------------+--------+------------+---------+--------------------+-----------------+------------+---------------+-------------------+----------+--+
| test06221700                                  |        |            |         | test06221700_user  | ROLE            | *          | false         | 1466589166501000  | --       |
| hdfs://nameservice1/hive/test06221700_upload  |        |            |         | test06221700_user  | ROLE            | *          | false         | 1466589582666000  | --       |
+-----------------------------------------------+--------+------------+---------+--------------------+-----------------+------------+---------------+-------------------+----------+--+

[root@cluster5node5 ~]# echo hdfs|kinit hdfs/test >/dev/null;beeline --silent=true -u "jdbc:hive2://master4:10000/default;principal=hive/cluster5node5.xxx.local@xxx.COM.TW" -e "show role grant group test06221700"
+--------------------+---------------+-------------+----------+--+
|        role        | grant_option  | grant_time  | grantor  |
+--------------------+---------------+-------------+----------+--+
| test06221700_user  | false         | NULL        | --       |
+--------------------+---------------+-------------+----------+--+
```


## config

the config file the automation scripts reads off from



