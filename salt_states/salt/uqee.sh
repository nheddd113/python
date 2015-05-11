#!/bin/bash

#错误提示
function error(){
    echo -e "\033[31m$* \033[0m"
    exit 2
}
#正常提示
function notify(){
    printf "\033[32m$* \033[0m"
}
. /lib/lsb/init-functions

function init(){
    id=$1
}
if [ $# -eq 0 ];then
    error "服务器ID不能为空"
fi
salt $1 saltutil.sync_all > /dev/null
notify "------------------------开始安装环境------------------------";
notify "\nsalt测试版本,本脚本将清除以下数据重新创建,请大家注意!"
notify "\ngamedb game_log battle_report,如无疑问任意键继续,否则Ctrl+C退出.\n"
read vir
notify "指定游戏安装包的名称:";read package
if [ -z $package ];then
    exit 1
fi
notify "是否启用日志中心:1.启用,0.不启用(默认) : ";read player_state
notify "\n是否启用HTTPS:1.启用,0.不启用(默认) : ";read ssl
if [ $ssl = 1 ];then
    salt $1 grains.setval ssl 1
else
    salt $1 grains.setval ssl 0
fi
if [ $player_state = 1 ];then
    salt $1 grains.setval player_state 1
else
    salt $1 grains.setval player_state 0
fi
salt $1 grains.setval gamepackage $package

salt $1 state.sls game
