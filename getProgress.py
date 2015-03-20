#!/usr/bin/env python
#encoding:utf-8
'''

下载文件, 支持进度条.


'''
import requests,sys
from urlparse import urlsplit
from os.path import basename
from progressbar import ProgressBar

class DownFile(object):
    filename = None
    url = None
    def __init__(self,url):
        self.filename = basename(urlsplit(url)[2])
        self.url = url
        
        
    def notify(self,msg,cl=32):
        return "\033[{0}m{1}\033[0m".format(cl,msg)               

    def download(self):
        print self.notify("开始下载{0}".format(self.filename))
        size = 0
        bs = 1024 * 8
        has_progress = False
        fp = open(self.filename,"wb")
        ret = requests.get(url,
                           auth=("username","password"),  #支持用户认证 HTTPBase，不需要认证不填此项
                           stream=True)
        if ret.status_code != 200:
            print self.notify("登陆失败或地址错误")
            return False

        if ret.headers.get("content-length"):
            has_progress = True
            size = int(ret.headers['Content-Length'])
            bar = ProgressBar(size).start()
        while True:
            chunk = ret.raw.read(bs)
            if chunk == '':
                break
            fp.write(chunk)
            if has_progress: bar.update(ret.raw.tell())
        ret.raw.close()
        if has_progress: bar.finish()
        fp.close()
        print self.notify("{0}: 已下载完成!".format(self.filename))



if __name__ == "__main__":
    if len(sys.argv) == 1:
        print "请填写下载地址!"
        sys.exit(1)
    url = sys.argv[1]
    model = DownFile(url)
    model.download()
                           
