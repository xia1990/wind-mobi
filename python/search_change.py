#!/usr/bin/python
#_*_ coding:utf-8 _*_
import json
import time
import subprocess as sp
import sys
import re
import os
import fileinput

user="yyuan2"
after_time="2019-01-23"
before_time="2019-02-15"
#merge的过滤时间

search_after_time="2019-01-23"
search_before_time="2019-02-16"
#gerrit上扩大时间范围的查找
#在提交merge后，仍旧可以更新提交信息，导致提交时间更新
#最好将 search_before_time 调整为今天的日期
#默认 只能查找到500个提交,查找范围过大可能会漏掉提交

change_str_list=[]
project_list=["titan/aosp/frameworks/base"] 
def print_color(message="hello world",fone_type=0,for_color="white",back_color="black"):
    for_color_dict={"black":30,"red":31,"green":32,"yellow":33,"blue":34,"magenta":35,"cyan":36,"white":37}
    bac_color_dict={"black":40,"red":41,"green":42,"yellow":43,"blue":44,"magenta":45,"cyan":46,"white":47}
    print("\033[%s;%s;%sm%s\033[0m" % (fone_type,for_color_dict[for_color],bac_color_dict[back_color],message))

def args_check():
    if len(project_list) == 0 :
        args_len = len(sys.argv)
        if args_len < 2:
            if len(project_list) == 0:
                print("no project name")
                sys.exit(1)
        get_project_list(sys.argv[1])
def clean_files():
    if os.path.isfile("change.json"):
        os.remove("change.json")
    if os.path.isfile("change_str.log"):
        os.remove("change_str.log")

def get_project_list(filename):
    if len(project_list) == 0 :
        for line in fileinput.input(filename):
            if fileinput.lineno() >= 3:
                project_list.append(line.split()[0])

def get_project_change(project):
    ssh_str="ssh -p 29418 %s@androidhub.harman.com gerrit query project:%s branch:titan_platform_oCar after:%s before:%s  is:merged --format JSON --current-patch-set --files | egrep 'project|^  number|revision|Depends-On:'" % (user,project,search_after_time,search_before_time)
    with open('change.json','w+') as change_file:
        p=sp.Popen(ssh_str,shell=True,stdout=change_file)
        p.wait()

def process_change_num(project):
    after_time_chuo=time.mktime(time.strptime(after_time,"%Y-%m-%d"))
    before_time_chuo=time.mktime(time.strptime(before_time,"%Y-%m-%d"))
    with open('change.json') as change_file:
        for line in change_file.readlines():
            change=json.loads(line)
            score_list=change['currentPatchSet']["approvals"]
            change_num = change["number"]
            files=change["currentPatchSet"]["files"]
            for item in score_list:
                if item["type"] == "SUBM":
                    change_merge_time=item['grantedOn']
                    if after_time_chuo < change_merge_time < before_time_chuo:
                        if project == "harman/bsp/titan/broxton":
                            for file_modified_message in files:
                                if re.findall('gwmv2',file_modified_message['file'],re.I) or re.findall('common',file_modified_message['file']):
                                    change_str_list.append('https://androidhub.harman.com/#/c/'+str(change_num))
                                    break
                        else:
                            change_str_list.append('https://androidhub.harman.com/#/c/'+str(change_num))
    with open("change_link.log","a+") as change_str_file:
        print_color("project: "+project,0,"blue")
        change_str_file.write(project+"\n")
        for line in sorted(change_str_list):
            print('    '+line)
            change_str_file.write('    '+line+"\n")
        print_color("")
        change_str_file.write("\n")

if __name__ == "__main__":
    clean_files()
    args_check()
    for project_name in project_list:
        get_project_change(project_name)
        process_change_num(project_name)
	change_str_list=[]
