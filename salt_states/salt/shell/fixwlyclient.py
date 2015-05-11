#!/usr/bin/env python
#encoding=utf-8
import xml.dom.minidom as Dom
import xml.etree.ElementTree as ET

import os,sys,urllib2
reload(sys)
#ident=sys.argv[1]
sys.setdefaultencoding('utf-8')
def clearformat(fp):
    from re import sub as resub
    fp=resub('\n','',fp)
    fp=resub('\t','',fp)
    fp=resub('\s+',' ',fp)
    fp=resub('>\s+<','><',fp)
    newxml=Dom.parseString(fp)
    xml = newxml.toprettyxml(indent="    ",encoding="utf-8").strip()
    return xml

def change(filename):
    data = {}
    tree = ET.parse(filename)
    root = tree.getroot()
#    for node in root.getchildren():
#        if node.tag == 'Mobile':
#            node.set('label',u'手机下载地址')
#            node.set('download','download')
#            node.set('ios','ios')
#            node.set('android','android')
#            node.set('limit','')
#            break
#    else:
#        mobileE=ET.SubElement(root,'Mobile')
#        mobileE.set('label',u'手机下载地址')
#        mobileE.set('download','download')
#        mobileE.set('ios','ios')
#        mobileE.set('android','android')
#        mobileE.set('limit','')
             
#    root.set('wf',"")
    for node in root.getchildren():
        if node.tag == 'BgList':
            node.text='i-15.swf'
#            node.set('resHost','s1.res.uqee.com,s2.res.uqee.com')
    #        node.set('host',"s%s.wly.91.uqeegame.com" % ident)
    #        print node.get('url')
#        if node.tag == 'Limit':
    tree.write(filename,encoding="utf-8")
    xml = clearformat(ET.tostring(root))
    os.rename(filename,filename+"_bak")
    fp = open(filename,"w")
    fp.write(xml)
    fp.close()
    return 0

def main():
    path = "/home/soidc/wly_web/config/"
    file_list = os.listdir(path)
    for afile in file_list:
        if afile.startswith("Servers") and afile.endswith(".dat"):
            change(os.path.join(path,afile))
    urllib2.urlopen("http://127.0.0.1/refresh.aspx")

if __name__ == '__main__':
    main()
