#!/usr/bin/python
#_*_ coding:utf-8 _*_

import hashlib
import sys

def get_md5(files):
	h=hashlib.md5()
	with open(files,'rb') as f:
		for line in f:
			h.update(line)
		return h.hexdigest()

if __name__=="__main__":
	be_md5_file=sys.argv[1]
	print(get_md5(be_md5_file))
