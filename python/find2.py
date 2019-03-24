#!/usr/bin/python
#_*_ coding:utf-8 _*_

def binary_search(data_source,find_n):
	mid=int(len(data_source)/2)
	if len(data_source)>=1:
		if data_source[mid]>find_n:
			binary_search(data_source[:mid],find_n)
		elif data_source[mid]<find_n:
			binary_search(data_source[mid:],find_n)
		else:
			print("找到了")

#data=list(range(1,100000))
data=[100,34,25,88,56,79]
binary_search(data,88)
