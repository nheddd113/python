#!/bin/bash 
#通过修改passwd.txt密文密码修改服务器账号密码

saltId=`cat /etc/salt/minion | grep ^id`
uqee=`cat /etc/passwd| grep ^uqee`

if [[ `whoami` == "root" ]];then 
    salt-call cp.get_file salt://changePwd/root.txt /tmp/root.txt
    salt-call cp.get_file salt://changePwd/uqee.txt /tmp/uqee.txt
else
    sudo salt-call cp.get_file salt://changePwd/root.txt /tmp/root.txt
    sudo salt-call cp.get_file salt://changePwd/uqee.txt /tmp/uqee.txt
fi
if [[ -n $uqee ]];then 
    chpasswd -e < /tmp/uqee.txt
fi  
chpasswd -e < /tmp/root.txt
