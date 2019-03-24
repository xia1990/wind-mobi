#!/usr/bin/python
#_*_ coding:utf-8 _*_

import subprocess


with open("message.txt","w") as f:
    #a=subprocess.Popen('ssh -p 29418 10.0.30.251 gerrit query branch:master after:"2018-12-28" before:"2019-01-04" project:^LNX_LA_MSM8917_PSW/.* status:merged --format JSON',shell=True,stdout=f)
    a=subprocess.Popen('ssh -p 29418 10.0.30.251 gerrit query branch:master after:"2018-12-28" before:"2019-01-04" project:LNX_LA_MSM8917_PSW/platform/vendor/qcom/proprietary status:merged --format JSON --current-patch-set --files | egrep "project^  number|revision|Depends-On" ',shell=True,stdout=f)


    
