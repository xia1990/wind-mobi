#!/usr/bin/python
#_*_　coding=utf-8 _*_
#选择排序
#　1. 选择一个基准球
#　2. 将基准球和余下的球进行一一比较，如果比基准球小，则进行交换
#　3. 第一轮过后获得最小的球
#　4. 在挑一个基准球，执行相同的动作得到次小的球
#　5. 继续执行4，直到排序好

def selectSort(list1):
	#循环次数
	for i in range(0,len(list1)):
		#基准值		
		samllnum=i
		for j in range(i+1,len(list1)):
			if list1[j]<list1[samllnum]:
				temp=list1[j]
				list1[j]=list1[samllnum]
				list1[samllnum]=temp
	return list1

list1=[12,3,44,0,67]
print(selectSort(list1))
			
		

