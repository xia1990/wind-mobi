#!/usr/bin/python
#_*_ coding:utf-8 _*_
#写入excel表格

import xlwt

table_head=['部门','姓名','联系方式','入职时间','地址']
table_content=[["测试部",'小王',15933333333,'2016-02-09',"四川，成都"],["测试部",'小张',15933333334,'2017-02-09','四川，雅安'],["测试部",'小李',15933333335,'2015-02-09','双流'],["开发部",'小熊1',15933333336,'2012-02-09','华阳'],["开发部",'小熊2',15933333337,'2014-12-31','华阳'],["市场部",'小熊3',15933333338,'2014-02-09','华阳']]


def write_excel():
    workbook=xlwt.Workbook(encoding="utf-8")
    worksheet=workbook.add_sheet("部门员工列表",cell_overwrite_ok=True)

    #写入表格的头部
    for i in range(len(table_head)):
        worksheet.write(0,i,table_head[i])

    #写入表格的内容
    #使用双重循环,外层循环控制列数，内层循环控制行
    for n in range(len(table_head)):
        for m in range(len(table_content)):
            worksheet.write(m+1,n,table_content[m][n])
    
    workbook.save("develope.xls")
if __name__=="__main__":
    write_excel()


