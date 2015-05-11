#!/bin/bash
if [ $# -eq 0 ];then

    exit 1
fi
if [ $1 = 'v1.4.4' ];then
    web=/mnt/db.bak/xl/versions/wly/v1.4.4/wly_web_v1.4.4.140828.tar.gz
    res=/mnt/db.bak/xl/versions/wly/v1.4.4/wly_res_v1.4.4.140828.tar.gz
    tar xf $web -C /home/soidc/wly_web
    tar xf $res -C /home/soidc/wly_web
    kill -9 `pgrep java`
    sleep 5
    invoke-rc.d tomcat start
    echo update success
    exit 0 
fi
if [ $1 = 'v1.4.3' ];then
    web=/mnt/db.bak/xl/versions/wly/v1.4.3/wly_web_v1.4.3.140828.tar.gz
    res=/mnt/db.bak/xl/versions/wly/v1.4.3/wly_res_v1.4.3.140828.tar.gz
    tar xf $web -C /home/soidc/wly_web
    tar xf $res -C /home/soidc/wly_web
    kill -9 `pgrep java`
    sleep 5
    invoke-rc.d tomcat start
    echo update success
    exit 0
fi
echo update version error
exit 1

