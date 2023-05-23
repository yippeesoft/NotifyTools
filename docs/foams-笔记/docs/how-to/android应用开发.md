---
title: android 应用 开发
date: 2022-03-09
type: 软件
tags: android, 开源, 软件,应用,
---

# android 应用

## 命令

### adb

```shell
adb reboot  recovery
adb root;adb disable-verity;adb reboot;adb wait-for-device;adb root;adb remount
adb bugreport 获取出错信息
```

### 修改系统设置

```java
<uses-permission android:name="android.permission.WRITE_SETTINGS" />
<uses-permission android:name="android.permission.WRITE_SECURE_SETTINGS" />
<uses-permission android:name="android.permission.CHANGE_CONFIGURATION" />
AndroidManifest.xml 添加 android:sharedUserId="android.uid.system".
```

### 强制 anr

[Android - Forcing ANR for testing purpose](https://stackoverflow.com/questions/13034837/android-forcing-anr-for-testing-purpose)

```java
@Override
public boolean onTouchEvent(MotionEvent event) {
    Log.d(TAG,"onTouchEvent");
    while(true) {}
}
```

### 智障 gradle

setting > Build, Execution, Deployment > Build Tools > Gradle > Gradle JDK 设置 gradle 目录和 jdk 版本
不然 as 这白痴每次都要下载一次 gradle 和报错 jdk 版本错误 JDK11 不能 JDK8.
保存了也没用.
和 android 配合各种版本不匹配提示智障的错误信息

```java
    repositories {
        maven { url 'https://maven.aliyun.com/repository/google/' }
        maven { url 'https://maven.aliyun.com/repository/jcenter/'}
    }
```

gradle 全局 阿里源头

```dotnetcli
https://zhuanlan.zhihu.com/p/427103768
```

各种碎片化...
[:compileDebugJavaWithJavac' property 'options.generatedSourceOutputDirectory](https://stackoverflow.com/questions/67606085/unitylibrarycompiledebugjavawithjavac)

```
gradle版本降级和 'com.android.tools.build:gradle: 匹配
```

### 权限 折腾

1. [Android 11 外部存储权限适配指南及方案](https://www.jianshu.com/p/e94cea26e213)
   升级 targetSdkVersion 30,或者 降低 targetSdkVersion 18 会自动提示授权,但是也会一直提示旧版本.
2. [Android 高版本联网失败报错:Cleartext HTTP traffic to xxx not permitted 解决方法](https://blog.csdn.net/gengkui9897/article/details/82863966)

### 脚本

andorid 还是不支持 javax.script.ScriptEngineManager.
kotlin 也不能用 kts.
Mozilla Rhino javaScript / LUA
[Android-LuaJavax](https://github.com/bennyhuo/Android-LuaJavax)
[rhino-android](https://github.com/APISENSE/rhino-android)
[Kotlin 如何运用 SPI 机制加载运行 kts 脚本](https://blog.csdn.net/qq_29278623/article/details/88888454)
[services](https://github.com/JetBrains/kotlin/blob/master/libraries/examples/kotlin-jsr223-local-example/src/main/resources/META-INF/services/javax.script.ScriptEngineFactory)
[kotlin-script-examples](https://github.com/Kotlin/kotlin-script-examples)

### 库搜索

由于网络问题,在[阿里云](https://developer.aliyun.com/mvn/search)上比较方便

### kotlin json

采用 fastjson
moshi: reflect.InvocationTargetException
gson : 不支持自定义 getter
jackson : 不支持 lateinit

### fiddle 抓包

[Fiddler 教程](https://www.cnblogs.com/TankXiao/archive/2012/02/06/2337728.html)
[Fiddler 抓取 https 设置详解（图文）](https://www.cnblogs.com/lihuali/p/10382007.html)
主要就是 https 增加证书
坑: 会被企业杀毒软件定义为病毒提示运行失败,没权限;启动后会联网,如果禁止了,代理就不会联网了.

### asset 内置 网页

[Android webview 加载本地 html 详细教程](https://blog.csdn.net/weixin_42289137/article/details/117883227)
也是奇怪,创建 一个和 res 同级的 assets 文件夹 ,然后用 file:///android_asset 访问

### logcat

新 logcat 设置

```dotnetcli
tag：与日志条目的 tag 字段匹配。
package：与日志记录应用的软件包名称匹配。
process：与日志记录应用的进程名称匹配。
message：与日志条目的消息部分匹配。
level：与指定或更高严重级别的日志匹配，例如 DEBUG。
age：如果条目时间戳是最近的，则匹配。值要指定为数字
```
