#!/usr/bin/python
#_*_ coding:utf-8 _*_

def isPhoneNumber(text):
    if len(text)!=12:
        return False
    for i in range(0,3):
        if not text[i].isdigit():
            return False
    if text[3]!='-':
        return False
    for i in range(4,7):
        if not text[i].isdigit():
            return False
    if text[7]!='-':
        return False
    for i in range(8,12):
        if not text[i].isdigit():
            return False
    return True

print('415-555-4242 is a phone number:')
print(isPhoneNumber('415-555-4242'))
print('Moshi moshi is a phone number:')
print(isPhoneNumber('Moshi moshi'))
