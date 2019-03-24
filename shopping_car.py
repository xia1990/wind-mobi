#!/usr/bin/python
#_*_ coding:utf-8 _*_

money=input("请输入你的总资产:")
goods=[
	{"name": "computer", "price": 1999},
	{"name": "mouse", "price": 10},
	{"name": "shap", "price": 20},
	{"name": "girl", "price": 998},
]
print("商品列表:")
for i in range(len(goods)):
	#下标从0开始所以要加1
	print(i+1,goods[i]["name"],goods[i]["price"])

#购物车
dicOne={}
#购买商品的总价
sumAccount=0
while 1:
	aOne=raw_input("请输入您购买商品序号(如您已经加入购物车完毕,请输入Q退出):").upper()
	if aOne=="Q":
		break
	else:
		aTwo=input("请输入购买商品数量:")
		#购买数量
		dicOne[aOne]=aTwo
		#下标从0开始要减1
		print("您将购买{},购买数量为{}".format(goods[int(aOne)-1]["name"],aTwo))
		totalAccount=goods[int(aOne)-1]["price"]*int(aTwo)
		sumAccount=sumAccount+totalAccount
		print("您购买商品总价为:",sumAccount)
		if sumAccount<=money:
			print("购买成功,剩余资产:{}".format(int(money-sumAccount)))
		else:
			print("余额不足,购买失败!")
	money=money-sumAccount
	assure=raw_input("是否还要购买,输入Y继续,输入N退出:")
	if assure=="N":
		break
