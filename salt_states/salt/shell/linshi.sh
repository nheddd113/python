#!/bin/bash
salt-call cp.get_file salt://nagios/check_lyingdragon /usr/local/nagios/libexec/check_lyingdragon
script_cp(){
sed -i "/corefile/d" /etc/rc.local
echo -e "/corefile/core.%e" >/proc/sys/kernel/core_pattern
sed -i '$iecho /corefile/core.%e >/proc/sys/kernel/core_pattern' /etc/rc.local 
}
#script_cp

#script_local(){
#if [ -L /usr/local/nagios/libexec/check_databak.py -o -L /usr/local/nagios/libexec/check_lyingdragon ];then
#    rm /usr/local/nagios/libexec/check_databak.py
#    rm /usr/local/nagios/libexec/check_lyingdragon
#    cp /mnt/db.bak/xl/python_xl/check_databak.py /usr/local/nagios/libexec/
#    cp /mnt/db.bak/xl/check_lyingdragon /usr/local/nagios/libexec/
#    echo "$HOSTNAME is ok" 
#fi
#}
#get_host_ip(){
#    ip=`ifconfig eth1 |grep inet |awk '{print $2}'|awk -F ":" '{print $2}'`
#    host=`hostname`
#    echo $host,$ip
#}
#install_pam(){
#    rm /etc/yum.repos.d/*.repo
#cat >/etc/yum.repos.d/CDROM.repo<<EOF
#[repo]
#name=iso2 for local software
#baseurl=http://192.168.15.91/CentOS/6.4/os/
#enabled=1
#gpgcheck=0
#
#[repoup]
#name=iso2 for local software
#baseurl=http://192.168.15.91/CentOS/6.4/updates/
#enabled=1
#gpgcheck=0
#
#[dell]
#name=iso2 for local software
#baseurl=http://192.168.15.91/repo/
#enabled=1
#gpgcheck=0
#
#[salt]
#name=iso2 for local software
#baseurl=http://192.168.15.91/salt/
#enabled=1
#gpgcheck=0
#EOF
#yum clean all
#yum makecache
#salt-call saltutil.refresh_pillar && salt-call saltutil.sync_all && /mnt/db.bak/xl/shell_xl/changeHostname.sh $HOSTNAME && salt-call state.sls pam
#}

