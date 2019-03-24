#!/usr/bin/python
#_*_ coding:utf-8 _*_

import os

for root,dirs,files in os.walk(".",topdown=True):
	for file in files:
		if file=="version":
			print("找到了！")
