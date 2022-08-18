---
title: linux 应用
date: 2022-02-28
type: 软件
tags: 开源, 软件,应用,ssh,vnc,linux,android,miniconada,git
---

# linux 应用

## 命令

### v2rayA
[V2rayA在linux 下安装使用教程](https://zhuanlan.zhihu.com/p/414998586)
```
sudo systemctl start v2raya.service //启动
 http://localhost:2017 界面
http proxy 端口:  20171
 sudo systemctl stop v2raya.service //停止
 sudo v2raya --reset-password //重置密码
```
###  neofetch  显示系统简要信息
###  编译工具
```shell
 sudo apt install   build-essential
 
```
### samba
   ```shell
   apt install samba
   smbpasswd -a ddd
   配置  /etc/samba/smb.conf
   [ddd]
   comment = Samba Share Directory for ddd
   path = /home/ddd/
   browseable = yes
   writable = yes
   guest ok = no
   read only = no
   public = no
   valid users = ddd
   log level = 1

   service smbd restart
   ```
### android sdk
[sdkmanager](https://developer.android.google.cn/studio/command-line/sdkmanager)
```
export ANDROID_SDK_ROOT=/opt/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/tools
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

sdkmanager "platform-tools" "platforms;android-23" “build-tools;30.0.3"
```

### miniconda
1.  [下载](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh) ubuntu18.04 默认py3.6
2.  chmod +x ; sh ..
3.  source .bashrc
4.  conda create -n frida python=python3.8 frida编译所需版本
   
### nodejs 升级
[安装说明](https://github.com/nodesource/distributions/blob/master/README.md#debinstall)
Node.js v17.x: Using Ubuntu
```
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
sudo apt-get install -y nodejs
```


### xrdp 
lxde
```shell
sudo apt-get install xrdp lxde lubuntu-core -y
echo "lxsession -e LXDE -s Lubuntu" > ~/.xsession
```
xfce4 : 升级到20.04后,LXDE似乎改成lxqt, openbox 没有任务栏等,改用xfce4.
任务栏修改锁定后最左拖动往下
```shell
sudo apt-get install xrdp xfce4 xubuntu-core -y
echo "xfce4-session" > ~/.xsession
```

rdp显示不同桌面问题
[RDP shows different desktop](https://zoringroup.com/forum/4/15865/)
```
sudo apt-get install gnome-tweak-tool -y
```

物理鼠标键盘不能用
```
sudo apt-get install xserver-xorg-input-all
```

### 输入法
尽量使用默认安装,升级后一些乱七八糟的问题.
fcitx5也不好配.各种依赖麻烦.

### disable ipv6
[在Ubuntu操作系统上禁用IPv6和重新启用IPv6的方法](https://ywnz.com/linuxjc/5099.html)
```shell
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
```

### 网络认证
目前linux msedge不能通过认证;firefox内存卡顿;改用chrome正常.
```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```

### apt 源
根据 各国内源 网站设置

### 语言修改
/etc/default/locale

### 命令行 注销
 pkill -KILL -u username
 pkill Xorg
 pkill -f firefox
 
 ### fcitx
 lubuntu 18.04 启动fcitx会导致xrdp卡死
 修正问题im-config运行出错:
 ```
dbind-WARNING **: Error retrieving accessibility bus address
sudo apt install at-spi2-core
 sudo apt install fcitx-frontend-qt4  fcitx-frontend-gtk2  fcitx-frontend-gtk3 fcitx-sunpinyin
 ```
再运行im-config设置fcitx.重启xrdp进行输入法设置,默认会addon-->cloudpinyin,来源改成baidu.
检测:fcitx-diagnose

###  is not in the sudoers file 
一般出现在新增用户,在原用户sudo passwd root,再sudo nano /etc/sudoers.
在 “root    ALL=(ALL)       ALL” 下面插入新的一行，内容是“ USERNAME   ALL=(ALL)       ALL”

### ubuntu回滚
[How to downgrade Ubuntu Linux system to its previous version](https://linuxconfig.org/how-to-downgrade-ubuntu-linux-system-to-its-previous-version)
实际测试20.04回退18.04依赖问题,回退失败.

### apt
public key is not available: NO_PUBKEY XXX
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys

/etc/apt/source.list //更换国内源
certificate is NOT trusted. //https改为http

### 关闭自动更新
[Ubuntu 20.04 如何禁用自动更新，删除更新提示和缓存](https://sysin.org/blog/disable-ubuntu-auto-update/)
```shell
# 关闭 Update-Package-Lists
sudo sed -i.bak 's/1/0/' /etc/apt/apt.conf.d/10periodic
# 关闭 unattended-upgrades
sudo sed -i.bak 's/1/0/' /etc/apt/apt.conf.d/20auto-upgrades
#删除提示
sudo rm -f /var/lib/update-notifier/updates-available
```

### fstab 挂载新硬盘
 sudo fdisk -l 查看硬盘
 sudo mount /dev/sdb1 ./DISKB 挂载到目录
  blkid /dev/sdb1 查看uuid
  UUID=b72a8f66-73d9-42d0-92cc-ae24bee6a309 /home/diska   ext4 errors=remount-ro 0       0  fstab增加,也可以直接/dev/sdb1 

  ### ssh 免密码
  ```shell
  将客户机的 id_rsa.pub 加入 服务器的  ~/.ssh/authorized_keys
  ```

  ### 声卡 sound
  options snd-hda-intel model=generic 
  之类的完全没用.. 18.04/20.04. 虽然alsamixer可以看到设备,但是播放只有虚拟设备.

  ### Setting locale failed
  [perl: warning: Setting locale failed.](https://easeapi.com/blog/blog/50-setting-locale-failed.html)
  ```shell
安装语言包,如apt-get install language-pack-zh-hans
vim ~/.bashrc
export LC_ALL=C
source ~/.bashrc
  ```

  ### ftp server
  vsftp手工改太麻烦了...filezilla-server-gui 比较简单,但是好像不支持列表
  ```
  suod apt install filezilla-server filezilla
  sudo /opt/filezilla-server/bin/filezilla-server
  sudo /opt/filezilla-server/bin/filezilla-server-gui
  ```