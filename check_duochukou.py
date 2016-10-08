#!/usr/bin/python
# -*- coding: UTF-8 -*-
# by richard

import sys,socket,re
import platform
import subprocess

def find_all_ip(platform):
    ipstr = '([0-9]{1,3}\.){3}[0-9]{1,3}'
    if platform == "Darwin" or platform == "Linux":
        ipconfig_process = subprocess.Popen("ifconfig", stdout=subprocess.PIPE)
        output = ipconfig_process.stdout.read()
        ip_pattern = re.compile('(inet %s)' % ipstr)
        if platform == "Linux":
            ip_pattern = re.compile('(inet addr:%s)' % ipstr)
        pattern = re.compile(ipstr)
        iplist = []
        for ipaddr in re.finditer(ip_pattern, str(output)):
            ip = pattern.search(ipaddr.group())
            if ip.group() != "127.0.0.1":
                iplist.append(ip.group())
        return iplist

c_ip = find_all_ip("Linux")
#print c_ip
fo = open('/usr/local/etc/3proxy/main.cfg', "r")
lines = fo.readlines()
for eachline in lines:
    line = eachline.split()
    if len(line)>3:
        ip = line[3].split(",")
        if len(ip)>2:
             lo =len(ip)
             ip_last=ip[lo-1].split("-")[0]
             ip[lo-1]=ip_last
#             print ip
             for i in ip:
                 if ip.count(i)>1:
                     print "chukou ip %s chongfu" %i
                     sys.exit(1)
                 else:
                     if i not in c_ip:
                         print "ip  %s is not ok" %i
                         sys.exit(2)
#                     else:
#                         print i
print "chukou is  ok-----------"
sys.exit(0)