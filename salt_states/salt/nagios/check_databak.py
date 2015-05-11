#!/usr/bin/env python
#encoding=utf8
import os,json,socket
import time
from ConfigParser import SafeConfigParser


def getconfig():
    config = SafeConfigParser()
    with open('/mnt/db.bak/xl/gameinfo.conf') as fp:
        config.readfp(fp)
    return config

def init():
    import salt.config,salt.minion
    opts = salt.config.minion_config("/etc/salt/minion")
    minion = salt.minion.SMinion(opts)
    return minion

def getServerId(gamename):
    jsonfile = "/etc/conf/uqee/%s/server/config.json" % gamename
    if not os.path.isfile(jsonfile):
        print jsonfile + 'is not exists!'
        exit(2)
    jsonret = json.load(open(jsonfile,"r"),encoding="utf-8")
    return jsonret['server']['id']


class mysocket(object):
    def __init__(self,filename,host,gamename):
        self.filename = filename
        self.gamename = gamename
        port = 60000
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.connect((host,port))

    def confirm(self):
        command = "query %s %s" % (self.filename,self.gamename)
        self.s.send(command)
        data = self.s.recv(4096)
        if data == "0":
            return True
        else:
            return data


if __name__ == '__main__':
    minion = init()
    config = getconfig()
    qianQuTime = 2
    checkTimeList = [1,9,17]
    # filename = "/etc/conf/uqee/gamename"
    # if not os.path.isfile(filename):
    #     print filename + ' is not exists'
    #     exit(2)
    hostFileTime = os.path.getmtime("/etc/hostname")
    dayStart = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00'),'%Y-%m-%d %H:%M:%S')) 
    dayEnd = time.mktime(time.strptime(time.strftime('%Y-%m-%d 23:59:59'),'%Y-%m-%d %H:%M:%S'))
    if hostFileTime > dayStart and hostFileTime < dayEnd:
        print r"Today is the first day,Skip!"
        exit(0)
    gamename = minion.functions['pillar.get']('game:gamename')
    gamepath = config.get(gamename,'gamename')
    if gamename == 'legendary':
        checkTimeList = [4,12,18,23] 
    currHour = int(time.strftime('%H')) 
    filetime = currHour - qianQuTime 
    currWday = int(time.strftime('%w'))
    if filetime < 0 :
        filetime += 24 
        currWday -= 1
        if currWday < 0 :
            currWday += 7
    if filetime not in checkTimeList:
        for itime in checkTimeList:
            if filetime <= itime:
                index = checkTimeList.index(itime) - 1
                if index < 0:
                    currWday -= 1
                    if currWday < 0 :
                        currWday += 7

                    index += len(checkTimeList)
                filetime = checkTimeList[index]
                break
    lastTime = checkTimeList.pop()
    if filetime > lastTime:
        filetime = lastTime
    serverid = getServerId(gamepath)
    bakdir = "/mnt/data/datacenter/%s/%s" %(gamename,serverid)
    checkFile = '%s/%s_%s_%s.tar.gz' %(bakdir,gamename,currWday,filetime)
    query = mysocket(checkFile,'databak.domain.com',gamename)
    ret = query.confirm()
    weekday = time.strftime('%A',time.strptime('%s' % currWday,'%w'))
    if ret == True:
        print r"%s : at %d o'clock on %s database backup success!" %(serverid,filetime,weekday)
        exit(0)
    else:
        ret = ret.split(':')
        if ret[0] == '2':
            bakFileTime = time.ctime(float(ret[1]))
            print "%s : at %d o'clock on %s database backup fail!   filename:%s    filetime:%s " %(serverid,filetime,weekday,checkFile,bakFileTime)
        else:
            print "%s : at %d o'clock on %s database backup fail!   filename:%s    desc:%s " %(serverid,filetime,weekday,checkFile,ret[1])
            
        exit(2)


            



