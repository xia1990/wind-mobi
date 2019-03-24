import requests
from requests.auth import HTTPBasicAuth
from requests.auth import HTTPDigestAuth
import json

auth=HTTPBasicAuth('gerrit', 'Xc8Cm2XtGXH2CeWv8gM7pvqRHJUEvh2BDc7Cp/E4+A')
auth2=HTTPDigestAuth('gerrit', 'Xc8Cm2XtGXH2CeWv8gM7pvqRHJUEvh2BDc7Cp/E4+A')
data=json.dumps({'name':'yaoyuanchun'})
#固定格式
header={'content-type': 'application/json;charset=UTF-8'}

def get_name(id,auth):
    r = requests.get('http://192.168.56.102:8083/a/accounts/self/name', auth=auth)
    return r.text[5:]

def set_name(id,auth,data,hearders):
	#auth是变量名称，固定不变，根据Gerrit来选择使用HTTPBasicAuth认证，还是使用HTTPDigestAuth认证
	#data是变量名称，固定不变，根据参数名称来传递值{'content-type': 'application/json;charset=UTF-8'}
	#headers是变量名称，值一般都为：
    r = requests.put('http://192.168.56.102:8083/a/accounts/self/name',auth=auth,data=data,headers=header)
    return r.text[5:]

if __name__ == "__main__":
    result=get_name('self', auth)
    print(result)
