#!/usr/bin/python
#_*_ coding:utf-8 _*_

import json

message={"name":"yaoyuanchun","age":12,"number":[1,2,3,4,5],"money":{"yuan":[10,20,50,10],"dollar":[5,10,15,20]}}

#message_1 = ['yaoyuanchun',12,[5,10,15,20]]
message_1=[message["name"],message["age"],message["money"]["dollar"]]
#print(message_1)

#message_2 = {'yaoyuanchun':{12:[10,20,50,10]}}
message_2={message["name"]:{message["age"]:message["money"]["dollar"]}}
#print(message_2)

#message_3 = {12:{'yaoyuanchun':15}} dollar中的15
message_3={message["age"]:{message["name"]:message["money"]["dollar"][2]}}
#print(message_3)

#第四步:将message 字典 用json模块 写入到文件
#方法一
with open("test.json","w") as f:
	#json.dumps将字典转成字符串
	f.write(json.dumps(message,indent=4))
	f.close()
#方法二
json.dump(message,open("test2.json","w"),indent=4)

#从第四步的 test.json 中提取 message为一个字典 然后用提取出message 做 1 2 3 步
#1：使用json读取文件
#2：重复1，2，3的步聚
with open("test.json","r") as f:
	#将字符串转换成字典json.loads
	new_data=json.loads(f.read())
	message_1=[new_data["name"],new_data["age"],new_data["money"]["dollar"]]
	print(message_1)
	message_2={new_data["name"]:{new_data["age"]:new_data["money"]["dollar"]}}
	print(message_2)
	message_3={new_data["age"]:{new_data["name"]:new_data["money"]["dollar"][2]}}
	print(message_3)


