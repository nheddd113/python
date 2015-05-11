def checkgame():
    gamelist = ['lyingdragon','dreamback','legendary','warcraft','naruto','q5','card']
    for game in gamelist:
        if __salt__['ps.pgrep'](game) != None:
            return '{0} already running'.format(game)
    return False

def hostname(new_alias):
    patterns = ['wly','mhjh','war','mycs','khbd','nwzr','yw','card']
    localhost = "127.0.0.1"
    hosts = __salt__['hosts.get_alias'](localhost)
    for alias in hosts:
        for patt in patterns:
            if alias.startswith(patt):
                __salt__['hosts.rm_host'](localhost,alias)
    with open('/etc/hostname',"wb") as fp:
        __salt__['cmd.run']('hostname {0}'.format(new_alias))
        fp.write(new_alias)
    return __salt__['hosts.add_host'](localhost,new_alias)

def checkwlan(*args,**kwargs):
    import re
    ipv4 = __grains__['ipv4']
    patterns = ['^10(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){3}$',
                '^172\.([1][6-9]|[2]\d|3[01])(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){2}$',
                '^192\.168(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){2}$',
                ]
    result = []
    for ip in ipv4:
        for patt in patterns:
            ret = re.match(patt,ip)
            if ret:
               result.append(ip)
               break
    if len(result) > 0:
        return False
    else:
        return True
    
            
