---
title: misc 应用 开发
date: 2022-03-09
type: 软件
tags: 杂项, 开源, 软件,应用,开发
---

## BOOST C++20

### 支持情况

godbolt.org 测试

1. clang15 :
   ```dotnetcli
   error: no template named 'awaitable' in namespace 'boost::asio'
    boost::asio::awaitable<void> coro_test() {
   ```
2. C++-10 同 clang15
3. C++-11 godbolt 可以;但是 UBUNTU20.04 安装后编译失败
4. C++-12 godbolt 正常;UBUNTU 22.04 正常
5. VS2022 开启 asan 会出现很多内存泄漏错误
6. VS2022 会莫名出现 error: 'fmt' is not a constant expression 等

## nodejs typescript

### ts import js

[Vue typeScript： Could not find a declaration file for module '**_'. '_**' implicitly has an 'any'](https://www.jianshu.com/p/02c42fc1ee59)
tsconfig.json 文件中在 compilerOptions 中添加 "noImplicitAny": false

[How to import js-modules into TypeScript file?](https://stackoverflow.com/questions/41219542/how-to-import-js-modules-into-typescript-file)
import \* as FriendCard from './../pages/FriendCard';
tsconfig.json compilerOptions 中添加 "allowJs": true
用法:FriendCard.xxx

### 代码块折叠

折叠代码块 C#中用 #region 和#endregion java 用 //region 和//endregion

### vcf 文件 解码

[VCF file stream to c#](https://stackoverflow.com/questions/15946503/vcf-file-stream-to-c-sharp)
[Importing a VCF file with quoted-printable encoding](https://mathematica.stackexchange.com/questions/111637/importing-a-vcf-file-with-quoted-printable-encoding)
URLDecode[StringReplace[Values[string], "=" -> "%"], CharacterEncoding -> "UTF-8"]}
vcf 搞得这么麻烦,就是 = 替换成 % ,让 url 解码好了..

### py use_2to3

[解决 python3 安装库报 use_2to3 is invalid 的错误](https://blog.51cto.com/u_15127588/4351216)

```
支持的版本一直在python 2.5+，于是在python3的版本进行安装的时候，会在setuptools里的setup函数里增加一个use_2to3=True的参数进行转换。
但是setuptools>=58的版本是不支持这个参数了（黑人问号），于是需要把版本降低，小于58的最后一个版本是57.5.0，pip降一下就可以了：
pip install setuptools==57.5.0
```

想整理 vcf(安卓后面到处都是所谓 qp 编码),试一试 vcf 整理 pyvcf,想想还是不要用了算了... 另外找解决方法

### jna

[JNA 实践](https://www.cnblogs.com/blogs-of-lxl/p/11013139.html)
[JNA 实践 Demo(包含转换 jar 工具)](https://github.com/dragonforgithub/JnaDemo)
