---
title: windows linux
date: 2022-02-28
type: 软件
tags: windows,  软件,应用
---

# windows 应用

## 
### WINDOWS 7 windows测试模式 
管理员运行cmd:
bcdedit /set testsigning off 关闭
bcdedit /set testsigning on 打开

### WINDOWS 7 ms edge
登录模式需要IE11.. (不是说已经不用了么..)

### WINDOWS 7 驱动数字签名
开始 - 运行（输入gpedit.msc） 用户配置 - 管理模板 - 系统 -驱动程序安装， 设备驱动的代码签名 设置忽略/禁用
找个realtek rtl8168/8111 找到个[驱动](https://driverpack.io/en/hwids/PCI%5CVEN_10EC%26DEV_8168?os=windows-7-x64)2021微软硬件兼容签名的(Microsoft Windows Hardware Compatibility Publisher),然后WIN7一直不认,改了设置也没用,直到最后找了个老版本的realtek签名的

### VCPKG
默认改为编译64位
```dotnetcli
VCPKG_DEFAULT_TRIPLET=x64-windows
```
cmake集成
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

###clangd
clangd的设置主要是通过设置编译参数的来实现的。
1.在vscode编辑中键入ctrl+shift+p打开命令输入框
2. 在命令输入框中输setting.json
3. 在setting.json中添加编译参数，这要是添加库的路径，不然编辑器会出现报错。
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
4.设置->禁用 C_Cpp: Autocomplete 控制自动完成提供程序 ("C_Cpp.intelliSenseEngine": "Disabled")
5.编译器选择 clang,vs不能生成compile_command.json
6.生成compile_command.json  (set(CMAKE_EXPORT_COMPILE_COMMANDS ON))

### 查看某个命令所在的路径
linux环境下的which命令就能看到某个命令的绝对路径,
windows环境下,通过where命令也能看到命令所在的位置

### win10 ssh-add 
win10不用git bash(出现ssh -T 成功,但是git失败,应该是ssh;ssh-agent;ssh-add等配套问题)
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

linux正常
[OpenSSH key management](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)
[Original answer using git's start-ssh-agent](https://stackoverflow.com/questions/18683092/how-to-run-ssh-add-on-windows)
开启:OpenSSH Authentication Agent;ssh-add ; git 设置ssh 都用 C:\Windows\System32\OpenSSH 的

### 简单几步解决win10连接wifi显示无internet访问的问题
【Internet协议版本4（TCP/IPv4）】高级 【WINS】，然后勾选下方的【启用TCP/IP上的NetBIOS】

### 在 Visual Studio Code 中安装 CodeRunner 插件后，直接运行 Java 代码的时候，输出窗口中的中文出现了乱码
打开 首选项 - 设置，在用户设置 
"code-runner.runInTerminal":true

## 吐槽
1. 现在更新真是没什么好写的了么,什么改个图标啊,改个记事本啊 都月月发
2. 补丁感觉就是减速带,一升级就变慢.
3. WIN10 已经干掉两块老机械硬盘了.
4. 更新 / store 时不时访问失败...
5. ms edge要不是看上同步功能。。那个启动增强也是够了。。。整机器都被霸占了，全是msedge，那还不如买个上网本算了。。;旧电脑msedge打开视频非常容易蓝屏死机.
6. WIN+V 的剪切板历史记录不会记录rdp的复制,并且非常容易导致rdp的复制丢失
7. firefox国内ip不能下载广告过滤软件了,其它的正常
8. 装完firefox/chrom/edge,定时任务加了好几个更新任务/信息收集上报