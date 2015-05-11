#!/bin/bash
ldapsearch -x -h 127.0.0.1 \
-b "uid=$1,ou=People,dc=uqeeauth,dc=com" \
'(objectClass=posixAccount)' \
'sshPublicKey' \
| sed -n '/^ /{H;d};/sshPublicKey:/x;$g;s/\n *//g;s/sshPublicKey: //gp'
