#!/usr/bin/python
#_*_ coding:utf-8 _*_

import xlwt
import xlrd
import time

filename="log.txt"

def set_style(name,height,bold=False):
    style=xlwt.XFStyle()
    pattern=xlwt.Pattern()
    pattern.pattern=xlwt.Pattern.SOLID_PATTERN
    #设置背景颜色
    pattern.pattern_fore_colour=7
    style.pattern=pattern
    #设置边框(为实线)
    borders=xlwt.Borders()
    borders.left=xlwt.Borders.THIN
    borders.right=xlwt.Borders.THIN
    borders.top=xlwt.Borders.THIN
    borders.bottom=xlwt.Borders.THIN
    style.borders=borders
    return style

def write_excel():
    f=xlwt.Workbook(encoding="utf-8")
    sheet1=f.add_sheet('学生',cell_overwrite_ok=True)
    row0=[u'序号',u'BUG号',u'调试单元',u'软件确认状态',u'软件确认时间',u'备注']

    #第一行(表头内容)
    for i in range(0,len(row0)):
        sheet1.write(0,i,row0[i],set_style('Times New Roman',220,True))

    with open(filename,"r") as f1:
        list1=f1.readlines()
        for i in range(len(list1)):
            sheet1.write(i+1,0,i+1)
            sheet1.write(i+1,2,list1[i])
            sheet1.write(i+1,3,"OK")
            sheet1.write(i+1,4,time.strftime("%Y%m%d"))
    f.save("update_code.xls")


if __name__=="__main__":
    write_excel()
    #read_excel()


