#!/usr/bin/env python
#encoding=utf-8
"""
自定义下载仓库文件
"""
from os.path import basename
from urlparse import urlsplit
import urllib2,sys,re,os
import threading,Queue

class DownLoadUrl(threading.Thread):
    def __init__(self,queue):
        self.queue = queue
        threading.Thread.__init__(self)
    def url2name(self,url):
        return basename(urlsplit(url)[2])

    def run(self):
        while not self.queue.empty():
            url = self.queue.get()
            localName = self.url2name(url)
            print localName
            ret = urllib2.urlopen(urllib2.Request(url))
            with open(localName,"wb") as _fp:
                _fp.write(ret.read())


def geturl(url):
    pair = r"rpm\">.*\.rpm"
    req = urllib2.Request(url)
    r = urllib2.urlopen(req,None,300)
    urls = list()
    while True:
        try:
            line = r.readline(4096)
        except:
            continue
        if not line:
            break
        try:
            localname = re.search(pair,line).group(0)[5:]
            urls.append(url+localname)
        except:
            continue
    return urls


def main():
    queue=Queue.Queue()
    urls = geturl(mainsite)
    #print urls
    for url in urls: queue.put(url)
    print queue.qsize()
    for i in xrange(thread_num):
        threads.append(DownLoadUrl(queue))
    for i in xrange(thread_num):
        threads[i].start()
    for i in xrange(thread_num):
        threads[i].join()
                       

if __name__ == '__main__':
    thread_num = 20
    threads = list()
    mainsite = "http://vault.centos.org/6.4/os/x86_64/Packages/"
    main()
    
    

