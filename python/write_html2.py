#!/usr/bin/python
#_*_ coding:utf-8 _*_

import json
import subprocess
import os

change_list=[]

def head():
    head_str="""
<html>
<body>
<table border="1" aligin="center">
    <tr>
        <th>project</th>
        <th>url</th>
    </tr>
"""
    return head_str

def foot():
    foot_str="""
    </table>
</body>
</html>
"""
    return foot_str

#清理文件
def clean_file():
    if os.path.isfile("message.txt"):
        os.remove("message.txt")
    if os.path.isfile("test.html"):
        os.remove("test.html")

#创建JSON文件
def create_change():
    with open("message.txt","w") as f1:
        #a=subprocess.Popen('ssh -p 29418 10.0.30.251 gerrit query branch:master after:"2018-12-28" before:"2019-01-04" project:LNX_LA_MSM8917_PSW/platform/vendor/qcom/proprietary status:merged --format JSON --current-patch-set --files | egrep "project^  number|revision|Depends-On" ',shell=True,stdout=f1)
        #a=subprocess.Popen('ssh -p 29418 10.0.30.251 gerrit query branch:master project:^LNX_LA_MSM8917_PSW/.* status:merged --format JSON --current-patch-set --files | egrep "project^  number|revision|Depends-On" ',shell=True,stdout=f1)

        a=subprocess.Popen('ssh -p 29418 10.0.30.10 gerrit query branch:master project:^LNX_LA_MSM8917_PSW/.* status:merged --format JSON --current-patch-set --files | egrep "project^  number|revision|Depends-On" ',shell=True,stdout=f1)
        #等待子线程执行shell命令
        a.wait()


def read_change():
    with open("message.txt","r") as f2:
        for line in f2.readlines():
            #print(line)
            #将字符串转换成字典
            dic1=json.loads(line)
            project=dic1["project"]
            number=dic1["number"]
            #change_list.append("http://10.0.30.251:8081/#/c/"+str(number))
            change_list.append("http://10.0.30.10:8081/#/c/"+str(number))
            print((change_list))

    heads=head()
    foots=foot()
    with open("test.html","a+") as f3:
        f3.write(heads)
        for m,n in enumerate(change_list):
            #str2='<tr><td>%s</td><td><a href="%s">%s</a></td></tr>' % (project,n,n)
            str2='''
            <tr>
                <td>%s</td>
                <td><a href="%s">%s</a></td>
            </tr>''' % (project,n,n)
            f3.write(str2)

    with open("test.html","a+") as f4:
        f4.write(foots)

if __name__=='__main__':
    clean_file()
    create_change()
    read_change()
