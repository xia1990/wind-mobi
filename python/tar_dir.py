#!/usr/bin/python
#_*_ coding:utf-8 _*_
#压缩某个目录下所有文件

import tarfile
import os

def compress_file(tarfilename,dirname):
    if os.path.isfile(dirname):
        with tarfile.open(tarfilename,"w") as tar:
            tar.add(dirname)
    else:
        with tarfile.open(tarfilename,"w") as tar:
            for root,dirs,files in os.walk(dirname):
                for single_file in files:
                    filepath=os.path.join(root,single_file)
                    tar.add(filepath)

#压缩某个文件夹下的一个文件
compress_file("nohlos.tar","NOHLOS/build_n.sh")
#压缩某个目录下所有文件
compress_file("nohlos2.tar",".")
