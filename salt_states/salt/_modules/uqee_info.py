# -*- coding: utf-8 -*-
import os
__virtualname__ = "uqee_info"
def __virtual__():
    config_file = "/mnt/db.bak/xl/gameinfo.conf"
    return __virtualname__ if os.path.isfile(config_file) else False


def _getAlias():
    from ConfigParser import SafeConfigParser
    config = SafeConfigParser()
    with open("/mnt/db.bak/xl/gameinfo.conf") as fp:
        config.readfp(fp)
    gamename = __salt__['pillar.get']("game:gamename")
    if gamename == 'None':
        return 'base'
    return config.get(gamename,'alias')


def getInfo(name=None,*args,**kwargs):
    '''
    查看服务器信息
    '''
    if name is None:
        name = _getAlias()
    name = "uqee_game.{0}".format(name)
    model = __salt__[name]()
    return model.getServerInfo()

def shutgame(name=None,*args,**kwargs):
    '''
    关游戏
    '''
    if name is None:
        name = _getAlias()
    name = "uqee_game.{0}".format(name) 
    model = __salt__[name]() 
    return model.shutgame()

def startgame(name=None,*args,**kwargs):
    '''
    开游戏
    '''
    if name is None:
        name = _getAlias()
    name = "uqee_game.{0}".format(name) 
    model = __salt__[name]() 
    return model.startgame()
def getConfigInfo(name=None,*args,**kwargs):
    '''
    查看配置.
    节点方式查看.
    key = server.name 查看配置的服务器名称
    '''
    if name is None:
        name = _getAlias()
    name = "uqee_game.{0}".format(name) 
    model = __salt__[name]() 
    return model.getAdminAddr(kwargs)
def setConfig(name=None,*args,**kwargs):
    '''
    修改配置
    key=server.name,value=测试服,bak=True
    修改服务器名称为 测试服 并备份原文件
    重启游戏后生效
    '''
    if name is None:
        name = _getAlias()
    name = "uqee_game.{0}".format(name) 
    model = __salt__[name]()
    params = model.getKeyMap(kwargs)
    if params.has_key("result") and \
            params['result'] is False:
        return params
    return model.setConfig(params)
    
def mhRollBack(name=None,*args,**kwargs):
    if name is None:
        name = _getAlias()

    if name != 'mhjh':
        ret = {"result": False,"comment":{"msg":"不支持该游戏"}}
        return ret
    name = "uqee_game.{0}".format(name)
    model = __salt__[name]()
    return model.rollBack(kwargs)

def getRoleInfo(name=None,*args,**kwargs):
    '''
    查询用户数据.
    '''
    if name is None:
        name = _getAlias()
    return __context__['cp.fileclient']
    
def sync_all(name=None,*args,**kwargs):
    '''
    同步模块
    '''
    if name is None:
        name = _getAlias()
    __salt__['saltutil.sync_all']()
    ret = {"result": True,"comment":{"msg":"刷新数据成功"}}
    return ret
    
