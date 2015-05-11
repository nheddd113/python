#!/usr/bin/env python
#encoding:utf8
#判断是否有外网ip， 如果没有就增加防火墙规则
import salt.config
import salt.loader
import os

opts = salt.config.minion_config("/etc/salt/minion")
mods = salt.loader.minion_mods(opts)
ips = ['eth0','eth1']

def intoLog(addr):
    fp = file('/mnt/db.bak/adai/iptable.log','a')
    fp.write(addr + '\n')
    fp.close()
for ip in ips:
    addr = mods['network.ip_addrs'](ip)
    if len(addr) == 0:
        continue
    if not addr[0].startswith('192.168.'):
        os.system('salt-call state.sls system.iptable')
        intoLog(addr[0])
