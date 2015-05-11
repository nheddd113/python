# -*- coding: utf-8 -*- 
def db_rename(name,port=5432):
    result = {}
    result['name'] = name
    result['changes'] = {}
    result['result'] = None
    result['comment'] = ''
    if not __salt__['postgres.db_exists'](name,port=port):
        result['comment'] = "{0} is not exists".format(name)
        result['result'] = True
        return result
    newname = '{0}_{1}'.format(name,'bak')
    if __salt__['postgres.db_exists'](newname,port=port):
        __salt__['postgres.db_remove'](newname,port=port)
    cmd = "alter database {0} rename to {1}" .format(name,newname)
    psql = "psql -h db -U postgres -p {0} -c '{1}'".format(port,cmd)
    ret = __salt__['cmd.run_all'](psql)
    if ret['retcode'] == 0:
        result['result'] = True
        result['comment'] = ret['stdout']
        result['changes'][name] = 'Rename to {0}'.format(newname)
    else:
        result['result'] = False
        result['comment'] = ret['stderr']
    return result

