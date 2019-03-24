#!/usr/bin/python
#_*_ coding:utf-8 _*_

#由于一趟只归为一个数，则如果有n个数字，则需要进行n-1趟。
#因为归位后的数字不用再比较了，所以每趟只需要比较n-1-i次（i为已执行的趟数）。

def bubbleSort(nums):
	#i外层循环控制循环的次数
	for i in range(len(nums)-1):
		#j下标,
		for j in range(len(nums)-i-1):
			if nums[j]>nums[j+1]:
				nums[j],nums[j+1]=nums[j+1],nums[j]
	return nums

nums=[5,2,45,8,2,1]
print bubbleSort(nums)
