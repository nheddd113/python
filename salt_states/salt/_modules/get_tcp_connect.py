#!/usr/bin/env python

import subprocess

def tcpconnect():
    tcp_status = subprocess.Popen("netstat -an|awk '/^tcp/ {++S[$NF]} END {for(a in S) print a,S[a]}'",stdout=subprocess.PIPE,shell=True)
    return tcp_status.stdout.read()
