#!/usr/bin/env python

#encoding=utf-8

import salt.config
import salt.minion

if __name__ == '__main__':
    opts = salt.config.minion_config('/etc/salt/minion')
    minion = salt.minion.SMinion(opts)
    minion.functions['file.replace']('/usr/local/nagios/etc/nrpe.cfg','=python','=sudo python')
    minion.functions['cmd.run']('invoke-rc.d nagios restart')
