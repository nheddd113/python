#!/bin/bash
#os=`lsb_release -i |awk '{print $3}'`
#if [ $os = "CentOS" ];then
    #echo $HOSTNAME
    ifconfig br1 |grep "inet addr"
    env x='() { :;}; echo "Your bash version is vulnerable"' bash -c "echo This is a test" 
#fi
