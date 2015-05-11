#!/bin/bash
#sed -i 's@binddn="cn=admin,dc=uqeeauth,dc=com"@binddn="olcDatabase=replsync,dc=uqeeauth,dc=com"@g' /etc/ldap/slapd.d/cn\=config/olcDatabase\=\{1\}bdb.ldif 
#sed -i 's@credentials="soidc..123"@credentials="Wt4tBw5med/+4/AFhc5rV+d728e2bmde"@g' /etc/ldap/slapd.d/cn\=config/olcDatabase\=\{1\}bdb.ldif 
cp /etc/ldap/slapd.d/cn\=config.ldif /root/cn\=config.ldif.bak
cp /etc/ldap/slapd.d/cn\=config/olcDatabase\=\{-1\}frontend.ldif /root/olcDatabase\=\{-1\}frontend.ldif.bak
#sed -i '/olcDisallows: bind_anon/d' /etc/ldap/slapd.d/cn\=config.ldif
#echo -e 'olcDisallows: bind_anon'  >> /etc/ldap/slapd.d/cn\=config.ldif
sed -i '/olcRequires: authc/d' /etc/ldap/slapd.d/cn\=config/olcDatabase\=\{-1\}frontend.ldif
echo -e  'olcRequires: authc' >> /etc/ldap/slapd.d/cn\=config/olcDatabase\=\{-1\}frontend.ldif
