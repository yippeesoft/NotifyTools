ifneq ($(KERNELRELEASE),)
	obj-m := hellolinuxdrv.o
else
	PWD := $(shell pwd)
	KDIR:= /usr/src/linux-headers-4.15.0-135-generic/ 
	#/usr/src/linux-headers-4.19.0-14-arm64
#KDIR := /lib/modules/`uname -r`/build
CONFIG_MODULE_SIG=n
all:
	make -C $(KDIR) M=$(PWD)
clean:
	rm -rf *.o *.ko *.mod.c *.symvers *.c~ *~
endif

# 作者：技术简说
# https://www.bilibili.com/read/cv7241587/
# 出处： bilibili