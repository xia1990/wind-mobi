#!/usr/bin/python
#_*_ coding:utf-8 _*_

import xlrd
from datetime import date,datetime

file="update_code.xls"

def read_excel():
    workbook=xlrd.open_workbook(file)
    #print(workbook.sheet_names())

    sheet1=workbook.sheet_by_index(0)
    #表格名称，行数，列数
    #print(sheet1.name,sheet1.nrows,sheet1.ncols)
    #得到第3行内容
    rows=sheet1.row_values(3)
    #得到第2列内容
    cols=sheet1.col_values(2)
    print(rows)
    #print(cols)

    #输出单元格内容的3种方法
    #输出第1行第2列的内容
    print(sheet1.cell(1,2).value.encode("utf-8"))
    #输出第2行第2列的内容
    print(sheet1.cell_value(2,2).encode("utf-8"))
    #输出第3行第2列的内容
    print(sheet1.row(3)[2].value.encode("utf-8"))

if __name__=="__main__":
    read_excel()
