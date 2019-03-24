#!/usr/bin/python3
#_*_ coding:utf-8 _*_

def count_str(str):
	digit_num=0
	char_num=0
	space_num=0
	other_num=0
	for i in str:
		if i.isdigit():
			digit_num+=1
		elif i.isalpha():
			char_num+=1
		elif i.isspace():
			space_num+=1
		else:
			other_num+=1

	print("数字：%d"%(digit_num))
	print("字母：%d"%(char_num))
	print("空格：%d"%(space_num))
	print("其它字符：%d"%(other_num))

str=raw_input("请输入一个字符串：")
count_str(str)
