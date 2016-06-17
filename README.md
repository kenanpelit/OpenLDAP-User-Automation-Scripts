These are scripts I used to add and delete OpenLDAP accounts. Not for anything beyond causal use. :)


## addldapgroup.sh

add the group

#### Usage: 


`addldapuser.sh <groupname> <grouptype>`
```
<groupname>: the ldap cn of group

<grouptype>: the ldap description of group type
```

#### Example:

```
[root@kdc ldap]# sh addldapgroup.sh gtest0615 3
adding new entry "cn=gtest0615,ou=group,dc=yy,dc=cht,dc=com,dc=tw"

Successfully, gidNumber=21316

[root@kdc ldap]# cat grp_gtest0615.ldif
dn: cn=gtest0615,ou=group,dc=yy,dc=cht,dc=com,dc=tw
objectClass: posixGroup
description: type3
gidNumber: 21316
cn: gtest0615

[root@kdc ldap]# ldapsearch -x -b 'cn=gtest0615,ou=group,dc=yy,dc=cht,dc=com,dc=tw' 'objectclass=*'
# extended LDIF
#
# LDAPv3
# base <cn=gtest0615,ou=group,dc=yy,dc=cht,dc=com,dc=tw> with scope subtree
# filter: objectclass=*
# requesting: ALL
#

# gtest0615, group, yy.cht.com.tw
dn: cn=gtest0615,ou=group,dc=yy,dc=cht,dc=com,dc=tw
objectClass: posixGroup
description: type3
gidNumber: 21316
cn: gtest0615

# search result
search: 2
result: 0 Success

# numResponses: 2
# numEntries: 1
```

## addldapuser.sh

adds the user

#### Usage: 

`addldapuser.sh <gidNumber> <username>`

```
<gidNumber>: the ldap gidNumber of user

<username>: the ldap uid of user
```

#### Example:

```
$ sh addldapuser.sh test0615 21316
adding new entry "uid=test0615,ou=people,dc=yy,dc=xx,dc=com,dc=tw"

Successfully, gidNumber=21316, uidNumber=25028

$ cat test0615.ldif
[root@kdc ldap]# cat usr_test0615.ldif
dn: uid=test0615,ou=people,dc=yy,dc=xx,dc=com,dc=tw
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
homeDirectory: /home/test0615
loginShell: /bin/bash
gidNumber: 21316
uidNumber: 25224
uid: test0615
cn: test0615
sn: test0615
userPassword: {CRYPT}vjc7w69zzbOwc

[root@kdc ldap]# ldapsearch -x -b 'uid=test0615,ou=people,dc=yy,dc=xx,dc=com,dc=tw' 'objectclass=*'
# extended LDIF
#
# LDAPv3
# base <uid=test0615,ou=people,dc=yy,dc=xx,dc=com,dc=tw> with scope subtree
# filter: objectclass=*
# requesting: ALL
#

# test0615, people, yy.xx.com.tw
dn: uid=test0615,ou=people,dc=yy,dc=xx,dc=com,dc=tw
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
homeDirectory: /home/test0615
loginShell: /bin/bash
gidNumber: 21316
uidNumber: 25028
uid: test0615
cn: test0615
sn: test0615
userPassword:: e0NSWVBUfWdJYXBlbXBZc2twOE0=
mail: test0615@xx.com.tw

# search result
search: 2
result: 0 Success

# numResponses: 2
# numEntries: 1
```

## delldapuser.sh

deletes user.

## config

the config file the automation scripts reads off from




