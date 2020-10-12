# rockchip linux 5.x build TODO!



```shell
继续努力 跨平台UI 20201012
本来windows-linux-armlinux就够折腾，rklinux改了不少东西，QT自己也有版本问题。编译个qt应用都麻烦。

一个最简单的标准lxde。准备最简单的qt跑起来。
还有不少警告错误。。。。
sudo su
startx &

https://blog.csdn.net/xgbing/article/details/79969640
rockchip linux平台的graphic，和以往大家所习惯所不同的是，我们应该是最先全面应用上drm和dmabuf的arm linux平台。

http://dev.t-firefly.com/thread-12739-1-1.html
http://bbs.icxbk.com/thread-97117-1-1.html

制作文件系统：
1.下载http://cdimage.ubuntu.com/ubuntu ... 3-base-arm64.tar.gz。我下载的是14.04，这个随意啦。
2.安装虚拟机apt-get install qemu-user-static
3.解压文件：
        mkdir temp
        tar -xpf ubuntu-base-16.04.1-base-arm64.tar.gz -C temp
4.运行虚拟机，把下载的ubuntu在虚拟机中跑起来，至少第二步是要做的，否则运行不了：
        cp -b /etc/resolv.conf temp/etc/resolv.conf
        cp /usr/bin/qemu-aarch64-static temp/usr/bin/
    在temp的上级目录中执行chroot temp，此时就是运行在虚拟机中了。

5.配置虚拟机中的ubuntu：
        apt update
        apt upgrade
        #可以安装桌面，如apt install xubuntu-desktop，我偷懒了，这样生成的文件小，制作和烧写的过程快。
        useradd -s '/bin/bash' -m -G adm,sudo firefly
        passwd firefly
        passwd root
        exit
退出后就回到主机的系统里了。

6.最后一步，生成rootfs文件：
        dd if=/dev/zero of=linuxroot.img bs=1M count=2048
        sudo  mkfs.ext4  linuxroot.img
        mkdir  rootfs
        sudo mount linuxroot.img rootfs/
        sudo cp -rfp temp/*  rootfs/
        sudo umount rootfs/
        e2fsck -p -f linuxroot.img
        resize2fs  -M linuxroot.img

最小lxde
sudo apt-get install xorg lxde-common lxsession desktop-file-utils openbox

```



```

悲惨的结果 20200928

1、原厂删库跑路怎么办。。。在线等。。挺急的。。。
https://github.com/rockchip-linux 下面只有9个repo了。docs、manifests。。。都删除了。

2、参考Leez-RK3399，但是是不同芯片，不能在原芯片上改

3、RK SDK是KERNEL 4.4、UBOOT 2017.9，现在KERNEL 5.9，UBOOT 2020.。。
乱改了下编译过了kernel烧了后崩。。。然后把2017的dtb塞到2020的UBOOT，但是RK又是按android启动image打包。。。

4、RK SDK倒是debian 10过了，但是apt装完lxde先要用户名密码，在rootfs上加了后进入命令行，但是 ui起不来了。
好像 X11和westom的冲突。

5、TK SDK下面有ubuntu.sh，但是编完也是UI不行

6、RK SDK还有什么gstream mpp。。也不知道到底兼容到什么程度。。。

7、RK SDK有QT GUI，但是QTWEBengine基于chromium，也忘了从哪里下了74.X，能正常运行。从rk-linux github上更新到83.X后，chromium要求安装GTK相关的组件了。。。

总之，这是一件令人忧伤的故事，嗯，中间还折腾了firefly等等其他的，除了各种分支。。
 ：）
```



```
目的
1、 https://aijishu.com/a/1060000000082887 在 RK3399 上运行开源的 Mali GPU 驱动  Run panfrost on rk3399
```

```
资料：
1、https://mp.weixin.qq.com/s/KZ1TflNpyWtZLMGcKtDyTQ  在 RK3399 上部署最新的 Linux 5.4 和 U-Boot v2020 .01 

```

```
问题
1、没有  Leez-RK3399

试图
1、https://mp.weixin.qq.com/s?__biz=MzAwMjQ1ODYyOQ==&mid=2247483683&idx=1&sn=9a791ac57afe7fe358560ac59a65145d&chksm=9acb5449adbcdd5fcfa123d25ce917b51c55218bad3e0feeb3077ac1990d0b6da1a35dfdb7bf&mpshare=1&scene=21&srcid=&sharer_sharetime=1575549252645&sharer_shareid=025223779ea46de7b8ccafe0bbfa3cc1#wechat_redirect  Linux Kernel 和 U-Boot 编译的那些事 


2、https://github.com/u-boot/u-boot/
3、https://github.com/torvalds/linux
```