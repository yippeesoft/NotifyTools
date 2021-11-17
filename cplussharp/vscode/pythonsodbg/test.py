from ctypes import cdll
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--ptvsd", action="store_true", help="de")
args = parser.parse_args()

# if args.ptvsd:
#     import ptvsd
#     ptvsd.enable_attach(address =('127.0.0.1', 10010), redirect_output=True)
#     ptvsd.wait_for_attach()

cur = cdll.LoadLibrary('/home/dmb/sfdev/pyso/build/libshufacv.so')
  
a = cur.addd(1, 2)
 
print(a)