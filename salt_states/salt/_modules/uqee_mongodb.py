# -*- coding: utf-8 -*- 
# Import third party libs
import logging
try:
    import pymongo
    HAS_MONGODB = True
except ImportError:
    HAS_MONGODB = False

log = logging.getLogger(__name__)

user = 'admin'
passwd = 'soidc..123'
port = 27017
host = '127.0.0.1'

def __virtual__():
    '''
    Only load this module if pymongo is installed
    '''
    if HAS_MONGODB:
        return 'uqee_mongodb'
    else:
        return False

def _connect(user=None, password=None, host=None, port=None, database='admin'):
    if not user:
        user = __salt__['config.option']('mongodb.user')
    if not password:
        password = __salt__['config.option']('mongodb.password')
    if not host:
        host = __salt__['config.option']('mongodb.host')
    if not port:
        port = __salt__['config.option']('mongodb.port')

    try:
        conn = pymongo.connection.Connection(host=host, port=port)
        mdb = pymongo.database.Database(conn, database)
        if user and password:
            mdb.authenticate(user, password)
    except pymongo.errors.PyMongoError:
        log.error('Error connecting to database {0}'.format(database))
        return False

    return conn

def initnode(obj,collection,database='admin'):
    conn = _connect(user,passwd,host,port)
    if not conn:
        log.error("connect mongodb failed")
        return False
    ret = findone({},collection,database)
    if ret is False:
        conn[database][collection].insert(obj)
        return True
    else:
        sid = ret.get('cluster').split(',')
        if obj['cluster'] not in sid:
            sid.append(obj['cluster'])
        obj['cluster'] = ','.join(sid)
        query = {"_id": ret['_id']}
        return update(obj,query,collection,database)
        
def update(obj,query,collection,database):
    conn = _connect(user,passwd,host,port) 
    if not conn:
        log.error("connect mongodb failed")
        return False
    
    conn[database][collection].update(query,obj)
    return True

def findone(obj,collection,database='admin'):
    conn = _connect(user,passwd,host,port)
    if not conn:
        log.error("connect mongodb failed")
        return False
    ret = conn[database][collection].find_one(obj)
    if isinstance(ret,dict):
        return ret
    else:
        return False

def find(obj,collection,database='admin'):
    conn = _connect(user,passwd,host,port)
    if not conn:
        log.error("connect mongodb failed")
        return False
    ret = conn[database][collection].find(obj)
    data = list()
    for i in ret:
        data.append(i)
    return data
    

def db_rename(name,port=27017):
    conn = _connect(user,passwd,host,port)
    if __salt__['mongodb.db_exists'](name,user,passwd,host,port):
        newname = name + "_bak"
        if __salt__['mongodb.db_exists'](newname,user,passwd,host,port):
            __salt__['mongodb.db_remove'](newname,user,passwd,host,port)
        try:
            conn.copy_database(name,newname,host,user,passwd)
            #__salt__['mongodb.db_remove'](name,user,passwd,host,port)
        except Exception as e:
            log.error("Error copy database, fromdb:{0},todb:{1}".format(
                    name,newname))
            return False
        return True
    else:
        #数据不存在.
        return True
