---
title: misc 应用 开发
date: 2022-03-09
type: 软件
tags: 杂项, 开源, 软件,应用,开发
---

##nodejs typescript

### ts import js
[Vue typeScript： Could not find a declaration file for module '***'. '***' implicitly has an 'any'](https://www.jianshu.com/p/02c42fc1ee59)
tsconfig.json文件中在compilerOptions 中添加 "noImplicitAny": false

[How to import js-modules into TypeScript file?](https://stackoverflow.com/questions/41219542/how-to-import-js-modules-into-typescript-file)
import * as FriendCard from './../pages/FriendCard';
tsconfig.json  compilerOptions 中添加  "allowJs": true
用法:FriendCard.xxx

### 代码块折叠
折叠代码块 C#中用 #region和#endregion   java用 //region和//endregion

### vcf 文件 解码
[VCF file stream to c#](https://stackoverflow.com/questions/15946503/vcf-file-stream-to-c-sharp)
[Importing a VCF file with quoted-printable encoding](https://mathematica.stackexchange.com/questions/111637/importing-a-vcf-file-with-quoted-printable-encoding)
 URLDecode[StringReplace[Values[string], "=" -> "%"],     CharacterEncoding -> "UTF-8"]}
vcf搞得这么麻烦,就是 = 替换成 % ,让url解码好了..

### py use_2to3
[解决python3安装库报use_2to3 is invalid的错误](https://blog.51cto.com/u_15127588/4351216)
```
支持的版本一直在python 2.5+，于是在python3的版本进行安装的时候，会在setuptools里的setup函数里增加一个use_2to3=True的参数进行转换。
但是setuptools>=58的版本是不支持这个参数了（黑人问号），于是需要把版本降低，小于58的最后一个版本是57.5.0，pip降一下就可以了：
pip install setuptools==57.5.0
```
想整理vcf(安卓后面到处都是所谓qp编码),试一试vcf整理pyvcf,想想还是不要用了算了... 另外找解决方法

### jna
[JNA实践](https://www.cnblogs.com/blogs-of-lxl/p/11013139.html)
[JNA实践Demo(包含转换jar工具)](https://github.com/dragonforgithub/JnaDemo)