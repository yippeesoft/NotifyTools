# 					rockchip linux 5.x build TODO!


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
我和我的失败，约在股市大跌，大跌的九月 。。。。。。。 ：）
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