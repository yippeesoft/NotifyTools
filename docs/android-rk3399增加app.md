# 					android 增加 apk

## 环境

​		ubuntu 18.04 android 8.1 rk3399

​       build-rk3399-all.sh

## 参考资料

```
https://titanwolf.org/Network/Articles/Article?AID=7f933d1f-d978-4d08-b269-45dc52ea97cf#gsc.tab=0

http://www.cxyzjd.com/article/q1183345443/53130384

```

## 内置 bilibili.apk

### 下载apk

### 编译

#### mm 
```
https://blog.csdn.net/code_for_fun/article/details/51741636

mm命令编译当前模块 
make snod命令重新打包system.img（默认会在 out/target/product/xx）

复制到刷机程序指定的目录目录(rockdev...)
```

```
根目录 make
```

###  新建 packages/apps/BILIBILI 目录


```
解压获得如下文件
/packages/apps/BILIBILI/.:
/packages/apps/BILIBILI/Android.mk
/packages/apps/BILIBILI/BILIBILI.apk
/packages/apps/BILIBILI/lib
/packages/apps/BILIBILI/
/packages/apps/BILIBILI/./lib:
/packages/apps/BILIBILI/armeabi-v7a
/packages/apps/BILIBILI/
/packages/apps/BILIBILI/./lib/armeabi-v7a:
/packages/apps/BILIBILI/libbili_core_dumper.so
/packages/apps/BILIBILI/libbili_core.so
/packages/apps/BILIBILI/libbilicr.81.0.4044.156.so
/packages/apps/BILIBILI/libbiliid.so
/packages/apps/BILIBILI/libbili.so
/packages/apps/BILIBILI/libbili-webp.so
/packages/apps/BILIBILI/libblkv.so
/packages/apps/BILIBILI/libBugly.so
/packages/apps/BILIBILI/libBurstLinker.so
/packages/apps/BILIBILI/libchronos.so
/packages/apps/BILIBILI/libcrypto_c.so
/packages/apps/BILIBILI/libc++_shared.so
/packages/apps/BILIBILI/libCtaApiLib.so
/packages/apps/BILIBILI/libdim.so
/packages/apps/BILIBILI/libed25519.so
/packages/apps/BILIBILI/libentryexpro.so
/packages/apps/BILIBILI/libfb_dalvik-internals.so
/packages/apps/BILIBILI/libgifimage.so
/packages/apps/BILIBILI/libijkffmpeg.so
/packages/apps/BILIBILI/libijkplayer.so
/packages/apps/BILIBILI/libijksdl.so
/packages/apps/BILIBILI/libimagepipeline.so
/packages/apps/BILIBILI/libjcore255.so
/packages/apps/BILIBILI/libjsc.so
/packages/apps/BILIBILI/libnative-filters.so
/packages/apps/BILIBILI/libnative-imagetranscoder.so
/packages/apps/BILIBILI/libnative-streaming.so
/packages/apps/BILIBILI/libndkbitmap.so
/packages/apps/BILIBILI/libnirvana.so
/packages/apps/BILIBILI/libspyder_core.so
/packages/apps/BILIBILI/libstatic-webp.so
/packages/apps/BILIBILI/libtencentloc.so
/packages/apps/BILIBILI/libuptsmaddon.so
/packages/apps/BILIBILI/libutility.so
/packages/apps/BILIBILI/libweibosdkcore.so
/packages/apps/BILIBILI/libwind.so
/packages/apps/BILIBILI/libxp2p.so
```

### Android.mk

```
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

# Module name should match apk name to be installed
LOCAL_MODULE := BILIBILI
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(LOCAL_MODULE).apk
LOCAL_BUILT_MODULE_STEM := package.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_PRIVILEGED_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
# LOCAL_DEX_PREOPT := false
LOCAL_MULTILIB := 32
LOCAL_PREBUILT_JNI_LIBS := \
  @lib/armeabi-v7a/libbili-webp.so \
  @lib/armeabi-v7a/libbili.so \
  @lib/armeabi-v7a/libbilicr.81.0.4044.156.so \
  @lib/armeabi-v7a/libbiliid.so \
  @lib/armeabi-v7a/libbili_core.so \
  @lib/armeabi-v7a/libbili_core_dumper.so \
  @lib/armeabi-v7a/libblkv.so \
  @lib/armeabi-v7a/libBugly.so \
  @lib/armeabi-v7a/libBurstLinker.so \
  @lib/armeabi-v7a/libc++_shared.so \
  @lib/armeabi-v7a/libchronos.so \
  @lib/armeabi-v7a/libcrypto_c.so \
  @lib/armeabi-v7a/libCtaApiLib.so \
  @lib/armeabi-v7a/libdim.so \
  @lib/armeabi-v7a/libed25519.so \
  @lib/armeabi-v7a/libentryexpro.so \
  @lib/armeabi-v7a/libfb_dalvik-internals.so \
  @lib/armeabi-v7a/libgifimage.so \
  @lib/armeabi-v7a/libijkffmpeg.so \
  @lib/armeabi-v7a/libijkplayer.so \
  @lib/armeabi-v7a/libijksdl.so \
  @lib/armeabi-v7a/libimagepipeline.so \
  @lib/armeabi-v7a/libjcore255.so \
  @lib/armeabi-v7a/libjsc.so \
  @lib/armeabi-v7a/libnative-filters.so \
  @lib/armeabi-v7a/libnative-imagetranscoder.so \
  @lib/armeabi-v7a/libnative-streaming.so \
  @lib/armeabi-v7a/libndkbitmap.so \
  @lib/armeabi-v7a/libnirvana.so \
  @lib/armeabi-v7a/libspyder_core.so \
  @lib/armeabi-v7a/libstatic-webp.so \
  @lib/armeabi-v7a/libtencentloc.so \
  @lib/armeabi-v7a/libuptsmaddon.so \
  @lib/armeabi-v7a/libutility.so \
  @lib/armeabi-v7a/libweibosdkcore.so \
  @lib/armeabi-v7a/libwind.so \
  @lib/armeabi-v7a/libxp2p.so
```

```
修改 device/rockchip/rk3399pro/

增加一行，编译的时候加入。

 PRODUCT_PACKAGES += BILIBILI

```

### repo 不熟， md吧

####  刷机的时候不能只刷 system.img,还要刷 misc.img，否则data区不会清空。

#### rockchip-linux只有kernel uboot了
####  rockchip-toybrick 差不多算清空了，据说版权问题整理。。都忘了手上这版本什么时候弄得了
####  rockchip官方ssh的rk3399pro好像不匹配toybrick的。。。

####  还可以放到别的apps目录下。。。。 先这样吧