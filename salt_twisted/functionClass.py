import psycopg2,json
class LoadJidsClass:
    def __init__(self,request):
        self.request = request
        self.conn = self._get_conn()

    def _get_conn(self):
        return psycopg2.connect(
            host = "localhost",
            user = "postgres",
            database = "salt",
            port = 5432
            )
    def __close_conn(conn):
        conn.commit()
        conn.close()
        return

    def getjids():
        conn = self._get_conn()
        cur = conn.cursor()
        sql = '''select * from jids'''
        cur.execute(sql)
        data = cur.fetchall()
        ret = dict()
        for jib,load in data.items():
            ret[jid] = json.loads(load)
        self._close_conn(conn)
        self.request.write(ret)
        self.request.finish()
        

