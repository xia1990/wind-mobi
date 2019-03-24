#!/usr/bin/python
import subprocess as sb #新的调用系统shell的模块，用来代替老的 os.system os.Popen等方法
import json #json格式数据处理模块

message={}
changes=[]

sshstring="ssh -p 29418 yyuan2@androidhub.harman.com gerrit query status:merged  branch:gwm-my19-mainline --format JSON --current-patch-set --files | sed -n '1,50p' | egrep 'project|^  number|revision|Depends-On:'"
#最后的egrep 是为了过滤 ssh 命令查询到json格式数据的最后一行，统计行的信息，这一行不要。

with open('message.json','w+') as json_file: #将ssh命令查询到的结果 写到 message.json 文件中
	process = sb.Popen(sshstring, shell=True,stdout=json_file, stderr=sb.STDOUT)
	process.wait() #等待shell 命令运行结束后再继续向下执行


with open('message.json') as json_file: #读取 message.json 文件。每次读取一行，并将这行json格式数据解析成python的字典，将字典放到一个叫changes的list里面
	for line in json_file.readlines():
		if not line:  #如果这行为空行 就跳过去
			continue
		changes.append(json.loads(line))


for change in changes:   #仔细观察json数据格式。能提取我们想要的信息即可。
	change_dict={}
	file_list=[]
	files_list=change[u'currentPatchSet'][u'files']
	for one_file in files_list:
		file_list.append(one_file[u'file'])
	change_dict[change[u'project']]=file_list
	message[change[u'number']]=change_dict

with open("finally.json",'w+') as ff:  #将message 这个字典 以好看的格式 写到 finally.json这个文件里面
	json.dump(message,ff,indent=4)
