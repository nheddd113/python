from functionClass import *
from twisted.web import http

class SaltQueryJob(http.Request):
    pageHandlers = {
        '/getJids': LoadJidsClass
        }
    def process(self):
        self.setHeader('Content-Type', 'text/html;charset=utf-8')
        if self.pageHandlers.has_key(self.path):
            handler = self.pageHandlers[self.path]
            handler(self)
        else:
            self.setResponseCode(http.NOT_FOUND)
            self.write("<h1>Not Found</h1>Sorry, no such page.")
            self.finish()
