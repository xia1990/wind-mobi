#!/usr/bin/python
#_*_ coding:utf-8 _*_

message={"name":"yaoyuanchun","age":12,"number":[1,2,3,4,5],"money":{"yuan":[10,20,50,10],"dollar":[5,10,15,20]}}
#打印message中的yaoyuanchun
print(message["name"])
#打印message中的number项里面的5
for i in message["number"]:
	if i==5:
		print(i)
#打印 message 中的 money 项里面的 dollar 项里面的 20
for i in message["money"]["dollar"]:
	if i==20:
		print(i)
