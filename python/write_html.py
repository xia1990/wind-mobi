#!/usr/bin/python
#_*_ coding:utf-8 _*_

import json
import subprocess
import os

change_list=[]
    
def clean_file():
    if os.path.isfile("message.txt"):
		os.system("rm -rf message.txt")
    if os.path.isfile("test.html"):
		os.system("rm -rf test.html")

def create_change():
    with open("message.txt","w") as f1:
        a=subprocess.Popen('ssh -p 29418 10.0.30.251 gerrit query branch:master after:"2018-12-28" before:"2019-01-04" project:LNX_LA_MSM8917_PSW/platform/vendor/qcom/proprietary status:merged --format JSON --current-patch-set --files | egrep "project^  number|revision|Depends-On" ',shell=True,stdout=f1)
        f1.close()


def read_change():
    with open("message.txt","r") as f2:
        for line in f2.readlines():
            print(line)
            dic1=json.loads(line)
            project=dic1["project"]
            number=dic1["number"]
            change_list.append(project+" "+"http://10.0.30.251:8082/#/c/"+str(number))
            print(change_list)
        f2.close()

def write_html():
    with open("test.html","a+") as f3:
        #m.write('table border="1px" cellspacing="1px" align="center"')
        f3.write("<th>project  url</th><br/>")
        for n in change_list:
            m.write("<br/>"+n+"<br/>")
        f3.close()

if __name__=="__main__":
    clean_file()
    create_change()
    read_change()
    write_html()
	
