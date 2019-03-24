#!/usr/bin/python
#_*_ coding:utf-8 _*_
#比较2个日期，当2个日期相等时，返回0


import time

#判断是不是一个有效的日期字符串
def is_valid_date(strdate):
	try:
		time.strptime(strdate,"%Y-%m-%d")
		return True
	except:
		return False

#比较2个日期，当2个日期相等时，返回0
def cpm_date(date1,date2):
	date1=raw_input("请输入第一个日期:")
	date2=raw_input("请输入第二个日期:")
	if is_valid_date(date1)==True and is_valid_date(date2)==True:
		y1,m1,d1=[int(x) for x in date1.split('-')]
		y2,m2,d2=[int(x) for x in date2.split('-')]
	
		if y1>y2:
			return 1
		elif y1<y2:
			return -1
		elif y1==y2:
			if m1>m2:
				return 1
			elif m1<m2:
				return -1
			elif m1==m2:
				if d1>d2:
					return 1
				elif d1<d2:
					return -1
				elif d1==d2:
					return 0
	else:
		print("日期格式不对!")

print(cpm_date("date1","date2"))
