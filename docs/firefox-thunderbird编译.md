# 					firefox-thunderbird编译

## 环境

​		WIN7 VS2019

​    

## 参考资料

https://developer.thunderbird.net/the-basics/building-thunderbird/windows-build-prerequisites

编译环境

```
安装 "Desktop development with C++" "Game development with C++"

安装 MAPI Headers

安装 MozillaBuild Package

下载源码

hg clone https://hg.mozilla.org/mozilla-central source/

cd source/

hg clone https://hg.mozilla.org/comm-central comm/
```



https://developer.thunderbird.net/the-basics/building-thunderbird

```
`source/`目录：

echo 'ac_add_options --enable-application=comm/mail' > mozconfig

echo 'ac_add_options --enable-calendar' >> mozconfig



运行 D:\mozilla-build\start-shell.bat

./mach build
```



https://firefox-source-docs.mozilla.org/build/buildsystem/locales.html#localization-repacks

中文版本

```
./mach build langpack-zh-CN
./mach build
./mach package
```



更新编译

hg pull -u

cd comm

hg pull -u

cd ..



但是会需要更新一些工具包，只能自行根据提示升级。



