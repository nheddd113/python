#!/bin/bash
file="/root/workspace/dreamback/log/dreamback.log.alarm"
if [ -f ${file} ];then
    err=`grep "is locked when flush" ${file} |wc -l`
    if [ $err -ge 10  ];then 
        echo "$HOSTNAME is locked when flush!!!"
        exit 1
    else 
        echo "$HOSTNAME just normal!"
        exit 0
    fi
else
    echo "$HOSTNAME at this versions don\'t support this action!"
    exit 0
fi
