#!/usr/bin/python
#_*_ coding:utf-8 _*_
#批量删除指定目录下的以指定后缀结尾的文件

import os

dirpath="/home/gerrit/Test3"
for filename in os.listdir(dirpath):
    if filename.endswith(".txt"):
        os.unlink(filename)
