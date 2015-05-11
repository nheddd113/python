#!/bin/bash
os=`lsb_release -i |awk '{print $3}'`
if [ $os = "Debian" ];then
    apt-get update
    apt-get install bash -y --force-yes 
fi
