---
title: windows linux
date: 2022-02-28
type: 软件
tags: windows,  软件,应用
---

# windows 应用

##

### WINDOWS 7 windows 测试模式

管理员运行 cmd:
bcdedit /set testsigning off 关闭
bcdedit /set testsigning on 打开

### WINDOWS 7 ms edge

登录模式需要 IE11.. (不是说已经不用了么..)

### WINDOWS 7 驱动数字签名

开始 - 运行（输入 gpedit.msc） 用户配置 - 管理模板 - 系统 -驱动程序安装， 设备驱动的代码签名 设置忽略/禁用
找个 realtek rtl8168/8111 找到个[驱动](https://driverpack.io/en/hwids/PCI%5CVEN_10EC%26DEV_8168?os=windows-7-x64)2021 微软硬件兼容签名的(Microsoft Windows Hardware Compatibility Publisher),然后 WIN7 一直不认,改了设置也没用,直到最后找了个老版本的 realtek 签名的

### VCPKG

#### 默认改为编译 64 位

```dotnetcli
环境变量:
VCPKG_DEFAULT_TRIPLET=x64-windows
```

```shell
vcpkg.bat

@echo off
IF "%1"=="install" ( set TRIPLET=--triplet x64-windows ) ELSE ( set TRIPLET= )
vcpkg-x86.exe %* %TRIPLET%
```

#### cmake 集成

```bash
set(CMAKE_TOOLCHAIN_FILE "E:/dev/vcpkg/scripts/buildsystems/vcpkg.cmake")
```

vscode(必需)

```bash
按F1（ctrl + shift + p），输入“setting.json"，打开设置，添加：

"cmake.configureSettings": {
    "CMAKE_TOOLCHAIN_FILE": "D:/vcpkg/scripts/buildsystems/vcpkg.cmake",
    "VCPKG_TARGET_TRIPLET": "x64-windows"
}
```

#### 清理

vcpkg remove --purge -recurse
删除 AppData\Local\vcpkg\archives 对应包
vcpkg\installed\x64-windows 对应目录
vcpkg\buildtrees 对应目录

### openssl libressl

openssl 3.x 取消了\*_\_update 等,怀疑处理大数据会有问题
改用 libressl
复制 FindLibreSSL.cmake 到 ....\cmake\share\cmake-3.22\Modules\FindLibreSSL.cmake
//https://github.com/openssl/openssl/issues/1093
/_ Under Win32 these are defined in wincrypt.h _/
/_ 修改 x509.h \*/
```powershell
#ifdef OPENSSL_SYS_WIN32

#include <windows.h>
#undef X509_NAME
#undef X509_EXTENSIONS
#endif
```

### vscode

#### cmake-format

安装插件
pip3 install cmakelang

#### clangd

clangd 的设置主要是通过设置编译参数的来实现的。 1.在 vscode 编辑中键入 ctrl+shift+p 打开命令输入框 2. 在命令输入框中输 setting.json 3. 在 setting.json 中添加编译参数，这要是添加库的路径，不然编辑器会出现报错。
添加方式如下

```json
{
  "clangd.fallbackFlags": [
    // 设置clangd代码检查的c++版本，目前默认是c++14
    "-std=c++17",
    // 增加项目自身头文件依赖路劲，因为使用vs2019编译不会生成compile_command.json文件，项目自己的头文件就不会找到
    "-I${workspaceFolder}", // 项目根目录
    "-I${workspaceFolder}/third_party/include" // 第三方依赖的头文件目录
  ]
}
```

4.设置->禁用 C_Cpp: Autocomplete 控制自动完成提供程序 ("C_Cpp.intelliSenseEngine": "Disabled") 5.编译器选择 clang,vs 不能生成 compile_command.json 6.生成 compile_command.json (set(CMAKE_EXPORT_COMPILE_COMMANDS ON))

### 查看某个命令所在的路径

linux 环境下的 which 命令就能看到某个命令的绝对路径,
windows 环境下,通过 where 命令也能看到命令所在的位置

### win10 ssh-add

win10 不用 git bash(出现 ssh -T 成功,但是 git 失败,应该是 ssh;ssh-agent;ssh-add 等配套问题)
调试:

```shell
set GIT_SSH_COMMAND=ssh -vvv 查看调试信息
新的ssh客户端不支持ssh-rsa算法，要修改本地配置重新使用ssh-rsa算法。
~/.ssh/config
增加:

Host *
HostkeyAlgorithms +ssh-rsa
PubkeyAcceptedKeyTypes +ssh-rsa

```

linux 正常
[OpenSSH key management](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)
[Original answer using git's start-ssh-agent](https://stackoverflow.com/questions/18683092/how-to-run-ssh-add-on-windows)
开启:OpenSSH Authentication Agent;ssh-add ; git 设置 ssh 都用 C:\Windows\System32\OpenSSH 的

### 简单几步解决 win10 连接 wifi 显示无 internet 访问的问题

【Internet 协议版本 4（TCP/IPv4）】高级 【WINS】，然后勾选下方的【启用 TCP/IP 上的 NetBIOS】

### 在 Visual Studio Code 中安装 CodeRunner 插件后，直接运行 Java 代码的时候，输出窗口中的中文出现了乱码

打开 首选项 - 设置，在用户设置
"code-runner.runInTerminal":true

### vs code

#### 括号对 设置颜色 启动匹对指示线

```dotnetcli
 settings.json


    "editor.bracketPairColorization.enabled": true,
    "editor.guides.bracketPairs":"active",


  "workbench.colorCustomizations": {
        "editorBracketHighlight.foreground1": "#b49900",
        "editorBracketHighlight.foreground2": "#c71fc1",
        "editorBracketHighlight.foreground3": "#2cbd0f",
        "editorBracketHighlight.foreground4": "#0e96f8",
        "editorBracketHighlight.foreground5": "#01cece",
        "editorBracketHighlight.foreground6": "#a3023b"
    },
```

## 吐槽

1. 现在更新真是没什么好写的了么,什么改个图标啊,改个记事本啊 都月月发
2. 补丁感觉就是减速带,一升级就变慢.
3. WIN10 已经干掉两块老机械硬盘了.
4. 更新 / store 时不时访问失败...
5. ms edge 要不是看上同步功能。。那个启动增强也是够了。。。整机器都被霸占了，全是 msedge，那还不如买个上网本算了。。;旧电脑 msedge 打开视频非常容易蓝屏死机.
6. WIN+V 的剪切板历史记录不会记录 rdp 的复制,并且非常容易导致 rdp 的复制丢失
7. firefox 国内 ip 不能下载广告过滤软件了,其它的正常
8. 装完 firefox/chrom/edge,定时任务加了好几个更新任务/信息收集上报
