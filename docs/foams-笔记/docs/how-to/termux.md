---
title: Termux 使用
date: 2022-02-28
type: 软件
tags: Termux, 开源, 软件,应用,ssh,vnc,linux
---

# Termux 笔记


## termux debian
[https://zhuanlan.zhihu.com/p/465031608](https://zhuanlan.zhihu.com/p/465031608)
### ssh替换
termux 安装 linux 后再apt install openssh-server，不能启动。
需要安装 apt install  dropbear，
运行 ： dropbear -E -p 2222 # -p指定端口

### Termux 设置
```
apt install x11-repo -y #下载x11源
termux-change-repo #更改国内源
apt install x11-repo -y #下载x11源
## 默认proot-distro从github拉取，修改 ../etc/proot-distro 的 对应linux.sh，例如debian.sh
proot-distro install debian #利用官方的proot-distro安装Debian
proot-distro login debian
```

### debian设置
```
apt install sudo -y
adduser tom
将新用户tom加入sudoers组里
nano /etc/sudoers
加入 tom ALL=(ALL:ALL) ALL, 
```

### debian gui
```
proot-distro login debian --user tom
sudo apt install xfdesktop4 xfwm4 xfce4-panel xfce4-settings thunar gvfs dbus-x11 xfce4-session xfce4-terminal -y
sudo apt install tigervnc-common tigervnc-standalone-server -y
```
VNC脚本
```
tigervncserver --localhost no -xstartup /usr/bin/xfce4-session -geometry 2560x1600 -depth 24 
```

### vncviewer
vncviewer默认8位颜色，需要手工修改
```
localhost:x #根据vnc执行提示
```

## termux 原生 

[图形界面](https://wiki.termux.com/wiki/Graphical_Environment)
[远程访问](https://wiki.termux.com/wiki/Remote_Access)
[为Termux安装图形化界面](https://blog.csdn.net/overfile/article/details/102828021)
[TERMUX安装XFCE](https://www.freesion.com/article/71481364681/)

### 安装包
```
pkg install x11-repo
pkg install xfce4              /* 安装桌面，注意这里是xfce，而不是xfce4 */
pkg install python
pkg install openbox      /*安装窗口管理器*/
pkg install pypanel       /*安装轻量级面板*/
pkg install xorg-xsetroot  /*安装将根窗口背景设置为给定模式或颜色的经典X实用程序，*/
pip3 install PyXDG
pkg install aterm &          /*安装终端*/
pkg install tigervnc
```

### 用vi启动编辑文件
vi startvnc
```
#!/bin/bash -e
export DISPLAY=:10  #在10号屏幕打开程序
Xvnc --SecurityTypes=None $DISPLAY & 
sleep 1s
openbox-session &  #打开敞口管理器
xsetroot -solid gray #把背景弄成灰色
pypanel &
aterm & #启动终端
startxfce4 #开启xfce桌面
```

### ssh
```
 pkg install openssh
 sshd 默认端口为 8022

termux查看ip，输入命令 ifconfig
termux查看用户名，输入命令 whoami
手机上termux设置密码，输入命令 passwd
```
### termux 运行
```
chmod +x startvnc 
./startvnc         /*启动*/
```
### vncviewer
```
localhost:5910
```
