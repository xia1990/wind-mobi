#!/usr/bin/python
#_*_ coding:utf-8 _*_
#遍历指定目录下的文件

import os

filepath="/home/gerrit/review_site"


for root,dir,file in os.walk(filepath):
    for d in dir:
        print(os.path.join(root,d))
    for f in file:
        print(os.path.join(root,f))
