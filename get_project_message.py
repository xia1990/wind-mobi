#!/usr/bin/python
import subprocess as sb
import json

message={}
changes=[]

sshstring="ssh -p 29418 yyuan2@androidhub.harman.com gerrit query status:merged  branch:gwm-my19-mainline --format JSON --current-patch-set --files | sed -n '1,50p' | egrep 'project|^  number|revision|Depends-On:'"
with open('message.json','w+') as json_file:
	process = sb.Popen(sshstring, shell=True,stdout=json_file, stderr=sb.STDOUT)
	process.wait()


with open('message.json') as json_file:
	for line in json_file.readlines():
		if not line:
			continue
		changes.append(json.loads(line))


for change in changes:
	change_dict={}
	file_list=[]
	files_list=change[u'currentPatchSet'][u'files']
	for one_file in files_list:
		file_list.append(one_file[u'file'])
	change_dict[change[u'project']]=file_list
	message[change[u'number']]=change_dict

with open("finally.json",'w+') as ff:
	json.dump(message,ff,indent=4)
