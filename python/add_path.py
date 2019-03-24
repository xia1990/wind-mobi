#!/usr/bin/python
#_*_ coding:utf-8 _*_
#给xml添加path属性

from xml.etree import ElementTree as ET

#解析XML文件
tree=ET.parse("manifest.xml")
#得到根节点
root=tree.getroot()

for node in root.iter("project"):
	#得到所有仓库的属性值
	list1=node.attrib
	#如果没有path属性，则添加path
	if "path" not in list1.keys():
		name=list1["name"]
		#添加属性
		#node.set("path",list1["name"])
		node.attrib["path"]=name
		tree.write("abc.xml")	
