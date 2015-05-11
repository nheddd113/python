# -*- coding: utf-8 -*-    
from ConfigParser import SafeConfigParser
import os,socket,json,urllib2,time,sys
import logging
import shutil
import salt.utils
reload(sys)
sys.setdefaultencoding("utf-8")

log = logging.getLogger(__name__)
__virtualname__ = "uqee_game"

config_file = "/mnt/db.bak/xl/gameinfo.conf"
def __virtual__():
    return __virtualname__ if os.path.isfile(config_file) else False


class base(object):
    ret = {"result": False,"error": "此服务器不支持该操作",
           "comment":["此服务器不支持该操作"]}
    def getServerInfo(self):
        return self.ret
    def shutgame(self):
        return self.ret
    def startgame(self):
        return self.ret
    def getAdminAddr(self):
        return self.ret
    def setConfig(self):
        return self.ret
    def rollBack(self):
        return self.ret


class wly(base):
    def __init__(self):
        self.dbname = "lyingdragon2"
        self.gamename = "lyingdragon"
        self.gamepath = self.gamename
        self.ip = "127.0.0.1"
        self.port = 5559
    def doSth(self,host,port,command,**kwargs):
        conn  = socket.socket(socket.AF_INET, socket.SOCK_STREAM)       
        try:
            conn.connect((host,port))
        except Exception as e:
            log.error("Connection {0}:{1} failed".format(host,port))
            return False
        conn.sendall(command)
        ret = ""
        while True:
            data = conn.recv(4096)
            if data == "":
                break
            ret += str(data)
        return ret.strip()

    def _getConfig(self):
        config = SafeConfigParser()
        if config_file:
            with open(config_file,"r") as _fp:
                config.readfp(_fp)
        return config

    def shutgame(self,*args,**kwargs):
        '''
        关闭游戏,
        '''
        ret = {"result": True,
               "comment": list()}
        __salt__['grains.setval']('is_notify',False)
        config = self._getConfig()
        flashGame = self.doSth(self.ip,self.port,"force_flush\n")
        if flashGame is False:
            ret['result'] = False
            ret['comment'].append("请注意: 连接游戏服务器失败.")
            log.error("Connection game server failed")
            return ret
        log.info(flashGame)
        shutGameData = self.doSth(self.ip,self.port,"shutdown\n")
        ret['comment'].append("关闭游戏成功!")
        log.info(shutGameData)
        time.sleep(5)
        __salt__['ps.pkill'](self.gamename,"root",9)
        is_mem = config.getboolean(self.gamename,'memcache')
        if is_mem is True:
            ret.update(self._closeMemcache())
        return ret

    def startgame(self,*args,**kwargs):
        '''
        开启游戏
        '''
        ret = {"result": True,"comment": dict()}
        config = self._getConfig()
        chkgame = self._checkGameCofnig()
        gameFileList = self._setGameFileList()
        if chkgame.get('log'):
            gameFileList.remove(chkgame['log'])
        if chkgame.get('store'):
            gameFileList.remove(chkgame['store'])
        os.environ['log_stdout'] = '1'
        for pathfile in gameFileList:
            if pathfile == "lyingdragon":
                path = "/root/workspace/{0}/{0}".format(pathfile)
            else:
                path = "/root/workspace/{0}".format(pathfile)
            cmd = "screen -mdS {0} ./{0}".format(pathfile)
            if self._checkRun(pathfile,'root'):
                ret['comment'].update({pathfile: "已经在运行,跳过"})
                log.warning("{0} already running,Skip!".format(pathfile))
                continue
            if not os.path.exists(os.path.join(path,pathfile)):
                ret['comment'].update({os.path.join(path,pathfile): "文件不存在,请注意"})
                log.warning("{0} is not exists".format(pathfile))
                ret['result'] = False
                continue
            startRet = __salt__['cmd.run_all'](cmd,cwd=path,shell="/bin/bash")
            if startRet['retcode'] == 0:
                ret['comment'].update({pathfile : "开启成功,请确认."})
            else:
                ret['result'] = False
                ret['commect'].update({pathfile : "开启失败,请让运维同事查看."})
                log.error("{0} was started failed!".format(pathfile))
                return ret
            time.sleep(5)
        return ret
    
    def getAdminAddr(self,params):
        ret = {"result":True,"comment": {}}
        config = self._getConfig()
        jsonfile = "/etc/conf/uqee/{0}/server/config.json".format(self.gamepath)
        if not params.has_key('key'):
            ret["result"] = False
            ret['commect'].update({"msg":"参数错误"})
        key = params.get('key')
        if not os.path.isfile(jsonfile):
            ret['result'] = False
            ret['comment'].update({"msg":"文件不存在"})
            return ret
        content = json.load(open(jsonfile,"r"),encoding="utf-8")
        for node in key.split('.'):
            content = content.get(node)
            if content is None:
                break
        ret['comment'].update({key:content})
        return ret
        
    def getKeyMap(self,params):
        keyDict = {
            "adminurl": "admin.url",
            "authip": "admin.auth.ip",
            "authuser" : "admin.auth.user",
            "servername": "server.name",
            "peername": "server.peer.name",
            "clusterid": "cluster.id",
            "paykey" : "ops.auth.pay",
            "domain": "server.report.address",
            "battleaddress" : "store.address"
            }
        if keyDict.has_key(params['key']):
            params['key'] = keyDict[params['key']]
            return params
        else:
            return {"result": False,"comment":{"msg":"不支持的方法"}}

    def setConfig(self,params):
        config = self._getConfig()
        ret = {"result":True,"comment": {}}
        if not params.has_key('key'):
            ret["result"] = False
            ret['commect'].update({"msg":"参数错误"})
        key = params.get('key')
        value = params.get("value")
        jsonfile = "/etc/conf/uqee/{0}/server/config.json".format(self.gamepath)   
        if not os.path.isfile(jsonfile):
            ret['result'] = False
            ret['comment'].update({"msg":"文件不存在"})
            return ret
        content = json.load(open(jsonfile,"r"),encoding="utf-8")
        if params.get("bak") is True:
            shutil.copy2(jsonfile,"{0}.{1}".format(jsonfile,int(time.time())))
        content = self._changeDict(content,key,value)
        with salt.utils.fopen(jsonfile,"w") as fp_:
            content = json.dumps(content,
                                 encoding="utf-8",
                                 ensure_ascii=False,
                                 indent=6,
                                 sort_keys=True)
            log.error(content)
            fp_.write(content)
            
            ret["comment"].update({"msg":"修改成功"})
        return ret

    def _changeDict(self,content,key,value):
        
        t = 'content'
        for i in key.split('.'):
            t += '["'+str(i)+'"]'
            if not content.has_key(i):
                exec(t + '={}')
        exec(t + '=value')
        return content

    def getCrossServer(self):
        ret = {"result":True,"comment": {}}
        config = self._getConfig()
        jsonfile = "/etc/conf/uqee/{0}/server/config.json".format(self.gamepath)
        if not os.path.isfile(jsonfile):
            ret['result'] = False
            ret['comment'].update({"msg":"文件不存在"})
            return ret
        content = json.load(open(jsonfile,"r"),encoding="utf-8") 
        if not content.has_key("cluster"):
            ret['result'] = False
            ret['comment'].update({"msg":"该服务器没有跨服配置"})
            return ret
        ret['comment'].update({"id":content['cluster']['id'].split(';')})
        return ret
        
            
    def _checkRun(self,name,user):
        '''
        检查即将要开启的这个程序是不是已经在运行了
        '''
        if __salt__['ps.pgrep'](name,user) != None:
            return True
        else:
            return False

    def _setGameFileList(self):
        '''
        返回开启游戏的程序名
        '''
        config = self._getConfig()
        gameFileList = list()
        gameFileList.append('foxlog')
        if config.getboolean(self.gamename,'foxstorage'):
            gameFileList.append('foxstorage')            
        if config.getboolean(self.gamename,'memcache'):
            gameFileList.append('memcache')
        if config.has_option(self.gamename,'other'):
            gameFileList += config.get(self.gamename,'other').split(',')
        gameFileList.append(self.gamename)
        return gameFileList

    def _checkGameCofnig(self):
        '''
        查看游戏的配置,检查是不是否日志和战报中心
        @return dict  返回启用情况   
        '''
        configfile = "/etc/conf/uqee/{0}/server/config.json".format(self.gamepath)
        if not os.path.isfile(configfile):
            return False
        content = json.load(open(configfile,"r"),encoding="utf-8")
        ret = dict()
        gamelog = content['game']['log'].get("tcp")
        if gamelog:
            logAddr = gamelog.get("center")
            if logAddr:
                ret['log'] = 'foxlog'
        battle = content.get("store")
        if battle:
            batt = battle.get("address")
            if batt:
                ret['store'] = "foxstorage"
        return ret
        
    def _closeMemcache(self):
        '''
        关闭MEMCACHE
        如果成功返回关闭信息
        '''
        port = 9208
        ret = {
            "closeMemcache": True,
            "commentMemcache":list()
            }
        flushMem = self.doSth(self.ip,port,"flush\n")
        if flushMem is False:
            ret['closeMemcache'] = False
            ret['commentMemcache'].append("请注意: 连接Memcache失败!") 
            log.error("Connection to Memcache failed!")
            return ret
        ret['commentMemcache'].append("关闭Memcache成功")
        log.info(flushMem)
        self.doSth(self.ip,port,'shutdown\n')
        __salt__['ps.pkill']('memcache','root',9)
        return ret

    def getServerInfo(self,**kwargs):
        import urllib2
        ip = "127.0.0.1"
        port = 5559
        url = 'http://%s:5280/public/player_num' % ip 
        try:
            result = json.loads(urllib2.urlopen(url).read())
        except Exception as e:
            result = {}
            log.error("open link:{0},{1}".format(url,e))
        data  = self.doSth(ip,port,"version\n")
        ret = {}
        if data == False:
            ret['server_version'] = None
        else:
            ret['server_version'] = data.split(" ")[0] 
        if result.has_key("online_num"):
            ret['online_number'] = result['online_num']
            ret['register_number'] = result['registed']
        else:
            ret['online_number'] = None
            ret['register_number'] = None
        ret.update(self._getIP())
        ret['client_version'] = __grains__['webversion']
        ret['gamename'] = self.gamename
        ret['result'] = True
        return ret
    def _getRegister(self):
        try:
            import pg
        except Exception as e:
            log.warning("import module: {0}".format(e))
            return {"register_number": None}
        config = self._getConfig()
        accounts = config.get(self.gamename,'acctb')
        sql = "select count(*) from {0}".format(accounts)
        conn = pg.DB(host='db',dbname=self.dbname,user="postgres")
        accountNum = conn.query(sql).dictresult()[0]['count']
        return {"register_number": accountNum}
    def _getIP(self):
        config = self._getConfig()
        jsonFile = "/etc/conf/uqee/{0}/server/config.json".format(self.gamepath)  
        if not os.path.isfile(jsonFile):
            return False
        jsonStr = json.load(open(jsonFile,"r"))
        ifname = jsonStr['server']['sock']['eth'].split(';')
        upIfname = __salt__['network.interfaces']()
        ret = {}
        for ifn in ifname:
            if upIfname.has_key(ifn) and \
                    upIfname[ifn]['up'] is True:
                inet = upIfname[ifn]['inet']
                for node in inet :
                    if ifn == node['label']:
                        ret['ipaddr'] = node['address']
                        break
            if ret.get('ipaddr'):
                break
        else:
            ret['ipaddr'] = None
        ret['server_id'] = jsonStr['server']['id']
        ret['server_name'] = jsonStr['server']['name']
        return ret
        

class khbd(wly):
    def __init__(self):
        self.dbname = "dreamback"
        self.gamename = self.dbname
        self.gamepath = self.dbname
        self.ip = "127.0.0.1"
        self.port = 8888
    def getServerInfo(self,*args,**kwargs):
        port = 8888
        host = "127.0.0.1"
        result = self.doSth(host,port,"ver\r\n")
        ret = {}
        ret.update(self._getRegister())
        ret.update(self._getIP())
        ret['gamename'] = self.gamename
        if result is False:
            ret['server_version'] = None
            ret['build_time'] = None
            log.warning("Get data faild")
        else:
            result = result.split(r'|')
            ret['server_version'] = result[0]
            ret['build_time'] = result[1]
        ret['result'] = True
        return ret
    def shutgame(self):
        '''
        关游戏
        '''
        ret = {"result": True,"comment": list()}
        __salt__['grains.setval']('is_notify',True)
        if self.doSth(self.ip,1122,"flush\n"):
            ret["comment"].append("请注意: 连接Tinytable服务器失败.")
            log.warning("Connection Tinytable failed!")
        flushData = self.doSth(self.ip,self.port,"flush\n")
        if flushData is False:
            ret['result'] = False
            ret['comment'].append("请注意: 连接游戏服务器失败.")
            log.error("Connection game server failed!")
            return ret
        log.info(flushData)
        shutData = self.doSth(self.ip,self.port,"shutdown\r\n")
        log.info(shutData)
        ret['comment'].append("关闭游戏成功!")
        time.sleep(10)
        __salt__['ps.pkill'](self.gamename,"root",9)
        is_mem = config.getboolean(self.gamename,'memcache')
        if is_mem is True:
            ret.update(self._closeMemcache())
        self.doSth(self.ip,1121,"flush\n") #强刷tinytable
        __salt__['ps.pkill']('tinytable',"root",9)  #KILL tinytable
        return ret

    def getKeyMap(self,params):
        keyDict = {
            "adminurl": "admin.url",
            "authip": "admin.auth.ip",
            "authuser" : "admin.auth.user",
            "servername": "server.name",
            "peername": "server.peer.name",
            "paykey" : "ops.auth.pay",
            "domain": "server.host",
            "clusterid" : "server.peer.cluster.id",
            "battleaddress" : "store.address"
            }
        if keyDict.has_key(params['key']):
            params['key'] = keyDict[params['key']]
            return params
        else:
            return {"result": False,"comment":{"msg":"不支持的方法"}}
        

class war(wly):
    def __init__(self):
        self.dbname = "warcraft"
        self.gamename = self.dbname
        self.gamepath = self.dbname
        self.ip = "127.0.0.1"
        self.port = 5559
    def getServerinfo(self,*args,**kwargs):
        port = 5559
        ip = "127.0.0.1"
        ret = {}
        version = self.doSth(ip,port,"version\n")
        if version is False:
            ret['server_version'] = None
            ret['online_number'] = None
            log.error("Get server info failed!")
        else:
            ret['server_version'] = version
            online = self.doSth(ip,port,"state\n")
            online = [x for x in online.split(r":")] 
            ret['online_number'] = online[1]
        log.info("{0}: {1}".format(version,online))
        ret.update(self._getRegister())
        ret.update(self._getIP())
        return ret
    def getKeyMap(self,params):
        keyDict = {
            "adminurl": "admin.url",
            "authip": "admin.auth.ip",
            "authuser" : "admin.auth.user",
            "servername": "server.name",
            "peername": "server.peer.name",
            "paykey" : "ops.auth.pay",
            "cluster": "cluster.id",
            "domain": "server.domain",
            "battleaddress" : "store.address"
            }
        if keyDict.has_key(params['key']):
            params['key'] = keyDict[params['key']]
            return params
        else:
            return {"result": False,"comment":{"msg":"不支持的方法"}}


class mhjh(wly):
    def __init__(self):
        self.dbname = "legendary"
        self.gamename = self.dbname
        self.gamepath = self.dbname
    def _initUrllib(self):
        username = "uqeeadmin"
        password = 'soidc..123'
        port = 9131
        ip = self._getIP()['ipaddr']
        _url = "http://%s:%s/admin/server" %(ip,port)
        password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()  #创建密码管理器
        password_mgr.add_password(None,_url,username,password)   #增加帐号密码到管理器
        handler = urllib2.HTTPBasicAuthHandler(password_mgr)    #生成handler
        opener = urllib2.build_opener(handler)    #生成opener
        urllib2.install_opener(opener)    #安装opener 
        return _url
        
    def getServerInfo(self,*args,**kwargs):
        _url = self._initUrllib()
        ret = {}
        try:
            result = urllib2.urlopen(_url)
            ret['online_number'] = result.read()
        except:
            ret['online_number'] = None
            log.error("Get server info failed")
        ret.update(self._getRegister())
        ret['gamename'] = self.gamename
        ret.update(self._getIP())
        ret['result'] = True
        return ret
    def shutgame(self):
        ret = {"result": True,"comment": list()}
        _url = self._initUrllib()
        __salt__['grains.setval']('is_notify',False)
        try:
            result = urllib2.urlopen(_url,'',1200)
            if result.code != 200:
                ret['result'] = False
                ret['commect'].append("请注意: 关闭游戏请求错误,检查帐号密码")
                log.error("Connection game server failed,please check username and password!")
                return ret
            ret['commect'].append("关闭游戏成功!!")
            time.sleep(10)
            __salt__['ps.pkill'](self.gamename,'root',9)
            config = self._getConfig()
            is_mem = config.getboolean(self.gamename,'memcache')
            if is_mem is True:
                ret.update(self._closeMemcache())
        except:
            ret['result'] = False
            ret['comment'].append("请注意: 打关闭游戏连接错误.")
            log.error("open link:{0} faild".format(_url))
            return ret
        return ret
    def getKeyMap(self,params):
        keyDict = {
            "adminurl": "admin.url",
            "authip": "admin.auth.ip",
            "authuser" : "admin.auth.user",
            "servername": "server.name",
            "peername": "server.peer.name",
            "paykey" : "ops.auth.pay",
            "domain": "server.report.address",
            "showname": "server.showname",
            "lang" : "server.language",
            "battleaddress" : "store.address"
            }
        if keyDict.has_key(params['key']):
            params['key'] = keyDict[params['key']]
            return params
        else:
            return {"result": False,"comment":{"msg":"不支持的方法"}}
    def rollBack(self,params):
        ret = {"result": True,"comment":{}}
        cmd = ['php']
        cmd.append(script)
        cmd.append('-m legendary')
        if kwargs.get("filename") and os.path.isfile(kwargs.get(filename)):
            cmd.append('-f {0}'.format(kwargs.get(filename)))
        else: #如果有指定备份文件退出
            ret["result"] = False 
            ret['comment'].update({"msg":"back filename is not specify"}) 
            return ret
        what = list()
        if kwargs.get('item'):
            what.append('i')
        if kwargs.get('pet'):
            what.append('p')
        if kwargs.get('askkey'):
            what.append('a')
        if len(what) == 0:
            ret["result"] = False    
            ret['comment'].update({"msg":"roll project is not specify"})  
            return ret
        else:
            cmd.append("-w {0}".format("".join(what)))
        if kwargs.get('roleid'):
            cmd.append("-u {0}".kwargs.get('roleid'))
        else:
            ret["result"] = False    
            ret['comment'].update({"msg":"roleid is not specify"})  
            return ret

        runningGame = __salt__['uqee_chkgame.checkgame']()
        if runningGame:
            ret["result"] = False
            ret['comment'].update({"msg":runningGame})
            return ret  #如果有游戏已经在运行. 返回检查结果 
        script = "/tmp/roleRollBack.php"
        source = "salt://conf/rollback_user.php"
        if not __salt__['cp.get_file'](source,script,makedirs=True):
            ret["result"] = False  
            ret['comment'].update({"msg":"update script failed"}) 
            return ret

        


class mycs(wly):
    def __init__(self):
        self.dbname = "naruto"
        self.gamename = self.dbname
        self.gamepath = self.dbname
        self.ip = None
        self.port = 9132
    def getServerInfo(self,*args,**kwargs):
        ip = self._getIP()['ipaddr']
        url = 'http://%s:9132/admin/online' % ip  
        ret = {}
        ret.update(self._getRegister())
        ret['gamename'] = self.gamename
        try :
            result = urllib2.urlopen(url).read()
            ret['online_number'] = result
        except:
            ret['online_number'] = None
            log.error("open link:{0} faild".format(url))
        url = 'http://%s:9130/serverinfo' %ip 
        try:
            result = eval(urllib2.urlopen(url).read())
            ret['server_version'] = result['version']
            res['build_time'] = result['build_date']
        except:
            ret['server_version'] = None
            ret['build_time'] = None
            log.error("open link:{0} faild".format(url))
        ret.update(self._getIP())
        ret['result'] = True
        return ret
    def shutgame(self):
        config = self._getConfig()
        ret = {"result": True,"comment": list()}
        __salt__['grains.setval']('is_notify',False)
        ip = self._getIP()['ipaddr']
        if not ip:
            ret['result'] = False
            ret['comment'].appeend('请注意: 解析服务器配置错误.')
            log.error("parse game config file failed")
            return ret
        _url = "http://%s:%s/admin/shutdown" % (ip,self.port)
        try:
            result= urllib2.urlopen(_url)
            if result.code != 200:
                ret['result'] = False
                ret['comment'].append("请注意: 关闭游戏请求错误.")
                log.error("close game failed, Code:{0}".format(result.code))
                return ret
            ret['comment'].append("关闭游戏成功!")
            time.sleep(10)
            __salt__['ps.pkill'](self.gamename,'root',9)
            is_mem = config.getboolean(self.gamename,'memcache')
            if is_mem is True:
                ret.update(self._closeMemcache())
            return ret
        except:
            ret['result'] = False
            ret['comment'].append("请求地址错误")
            log.errpr("open link:{0} failed".format(_url))
            return ret

    def getKeyMap(self,params):
        keyDict = {
            "adminurl": "admin.url",
            "authip": "admin.auth.ip",
            "authuser" : "admin.auth.user",
            "servername": "server.name",
            "peername": "server.peer.name",
            "paykey" : "ops.auth.pay",
            "domain": "server.report.address",
            "battleaddress" : "store.address",
            "clusterid" : "cluster.id"
            }
        if keyDict.has_key(params['key']):
            params['key'] = keyDict[params['key']]
            return params
        else:
            return {"result": False,"comment":{"msg":"不支持的方法"}}



class nwzr(wly):
    '''
    女巫之刃相关操作
    关游戏开游戏 都继承卧龙吟的方法
    '''
    def __init__(self):
        self.dbname = "nwzr"
        self.gamename = "q5"
        self.gamepath = self.dbname
        self.ip = "127.0.0.1"
        self.port = 5559

    def getServerInfo(self):
        ret = {"gamename":self.gamename}
        ip = self._getIP()['ipaddr']
        if not ip:
            return ret
        url = "http://{0}:5280/serverinfo".format(ip)
        try:
            result = eval(urllib2.urlopen(url).read().strip())
            ret['online_number'] = result['online_num']
            ret['server_number'] = result['version']
            ret['register_number'] = result['account_num']
            ret['build_time'] = result['build_date']
            ret['server_time'] = result['now']
            ret['gamename'] = self.gamename
        except:
            log.error("open link:{0} faild".format(url))
            return ret
        ret['result'] = True
        return ret
    def getKeyMap(self,params):
        keyDict = {
            "adminurl": "admin.url",
            "authip": "admin.auth.ip",
            "authuser" : "admin.auth.user",
            "servername": "server.name",
            "peername": "server.peer.name",
            "paykey" : "ops.auth.pay",
            "domain": "server.report.address",
            "battleaddress" : "store.address",
            }
        if keyDict.has_key(params['key']):
            params['key'] = keyDict[params['key']]
            return params
        else:
            return {"result": False,"comment":{"msg":"不支持的方法"}}

        

