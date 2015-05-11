# -*- coding: utf-8 -*-    
def copyfile(source,dest):
    private = "/tmp/private"
    r = __salt__['cp.get_file'](
        "salt://system/baolei/id_dsa",
        private
        )
    if r != private:
        return False
    else:
        __salt__['cmd.run']("chmod 600 {0}".format(r))
    cmd = "scp -r -o StrictHostKeyChecking=no"\
        " -i {3}" \
        " root@{0}:{1} {2}".format(__grains__['prev'],
                                   source,
                                   dest,
                                   r
                                   )
    if not __salt__['file.directory_exists'](dest):
        __salt__['file.makedirs'](dest)

    ret = __salt__['cmd.run_all'](cmd)
    __salt__['file.remove'](r)
    if ret['retcode'] == 0:   
        return True        
    return ret['stderr']
