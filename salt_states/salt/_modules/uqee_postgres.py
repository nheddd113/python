# -*- coding: utf-8 -*-
import time
def db_rename(name,port=5432):
    if __salt__['postgres.db_exists'](name,port=port):
        newname = '{0}_bak'.format(name)
        __salt__['postgres.db_exists'](newname) and __salt__['postgres.db_remove'](newname)
        cmd = "alter database {0} rename to {1}" .format(name,newname)
        psql = "psql -h db -U postgres -p {0} -c '{1}'".format(port,cmd)
        ret = __salt__['cmd.run_all'](psql)
        if ret['retcode'] == 0:
            return True
        else:
            return False
    else:
        return True
def db_back(name,port=5432):
    if __salt__['postgres.db_exists'](name):
        cmd = 'pg_dump -U postgres -h db {0} -f /var/lib/postgresql/{1}_{2}.bak'.format(name,name,time.strftime('%Y-%m-%d_%H:%M:%S'))
        ret = __salt__['cmd.run_all'](cmd)
        if ret['retcode'] == 0:
            return True
        else:
            return False
    else:
        return True
            
