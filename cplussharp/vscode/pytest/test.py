import ctypes
from ctypes import *

ncnn = ctypes.CDLL("./libncnn.so")
ncnn.ncnn_version.restype = ctypes.c_char_p
# ncnn.ncnn_version()
pStr = ncnn.ncnn_version()

print("hello py!" + str(pStr, encoding="utf8"))
test = ctypes.CDLL("./libtest.so")
buffer = "\x01\x01\x02"
print(buffer)
mydata = bytearray([65, 66, 67, 68, 69, 70, 71])
print(mydata)

# test.printt.argtypes = [ctypes.POINTER(ctypes.c_ubyte), ctypes.c_size_t]
# b = (c_ubyte * 2)(b'\x02', b'\x01')
# cast(buffer, POINTER(buffer))
return_value = (c_ubyte * 3)()
byte_arr = bytearray(buffer, 'utf-8')

result = (ctypes.c_ubyte * 20)(*(byte_arr))
# return_value[0] = '\x01'
test.printt(result, 3)

pdata = (c_ubyte * 3)()
pdata = test.testbytes(result, 3)
b_result = ctypes.string_at(pdata, len(buffer))
print(b_result)

result = (ctypes.c_ubyte * 20)(*(b_result))
test.printt(result, 3)

print("byref test")
test.printt(byref(result), 3)

# pdata = bytearray(pdata, 'utf-8')
# result = (ctypes.c_ubyte * 20)(*(pdata))
# test.printt(pdata, 3)


# https://www.cnblogs.com/fendou-999/p/3527449.html?utm_source=tuicool&utm_medium=referral
# 应该还可以用byref
def aaa():
    ccc = 1
    print("aaa " + str(ccc))


aaa()