#!/usr/bin/env python      
#encoding=utf-8
from RequestClass import SaltQueryJob
from twisted.web import http
class SaltHttp(http.HTTPChannel):
    requestFactory = SaltQueryJob

class SaltFactory(http.HTTPFactory):
    protocol = SaltHttp

if __name__ == "__main__":
    from twisted.internet import reactor
    reactor.listenTCP(9123,SaltFactory())
    reactor.run()
