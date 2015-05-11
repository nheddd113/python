#!/usr/bin/env python
#encoding=utf-8

import salt

opt = salt.config.master_config('/etc/salt/master')
__salt__ = salt.loader.minion_mods(opt)
hostlist = __salt__['hosts.list_hosts']()
fp = open('hostlist.txt',"w")
for host,alias in hostlist.items():
    if host.startswith("192.168") and not alias[0].startswith('xen'):
        fp.write("%s\n"%host)

fp.close()
