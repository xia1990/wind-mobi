#!/usr/bin/python
#_*_ coding:utf-8 _*_
#判断闰年

m=[1,2,3,4,5,6,7,8,9,10,11,12]
d1=[31,28,31,30,31,30,31,31,30,31,30,31]
d2=[31,29,31,30,31,30,31,31,30,31,30,31]

def isYear(year):
	year=input("请输入一个年份：")
	#能被4和100整除
	if year%4==0 and year%100!=0 or year%400==0:
		print("闰年")
	#能被400整除
	else:
		print("不是闰年")
	
isYear("year")
