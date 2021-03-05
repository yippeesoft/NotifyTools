linux 驱动开发 hello

```
20210305
1、注意Makefile tab cat -t Makefile //https://blog.csdn.net/u011852211/article/details/81328869

2、需要linux headers //

3、查看printk : dmesg

4、查看安装：  lsmod | grep hello*

5、CONFIG_MODULE_SIG=n 去除module verification failed

```

```
aarch64 debian
1、sudo apt-cache search linux-headers
2、sudo apt install linux-headers-4.19.0-14-all
....
最终 insmod “Invalid module format ” 似乎是因为版本匹配问题

```

```
x64 ubuntu ok

[2774506.529284] hellolinuxdrv: loading out-of-tree module taints kernel.
[2774506.529334] hellolinuxdrv: module verification failed: signature and/or required key missing - tainting kernel
[2774506.529471] hello world init !
[2774893.580094] hello world exit !

```