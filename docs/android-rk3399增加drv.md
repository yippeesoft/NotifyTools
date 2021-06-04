# 					rk3399 增加 driver test

## 环境

​		ubuntu 18.04 android 8.1 rk3399

​       build-rk3399-all.sh

## driver代码  
cplussharp\linuxdrv-hello\demo
复制到 kernle\drivers
按kernel编译

```
diff --git a/arch/arm64/configs/rockchip_defconfig b/arch/arm64/configs/rockchip_defconfig
index 6769bded69ee..c3530ace2fe0 100755
--- a/arch/arm64/configs/rockchip_defconfig
+++ b/arch/arm64/configs/rockchip_defconfig
@@ -831,3 +831,5 @@ CONFIG_CRYPTO_GHASH_ARM64_CE=y
 CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
 CONFIG_CRYPTO_AES_ARM64_CE_BLK=y
 CONFIG_CRYPTO_CRC32_ARM64=y
+CONFIG_DEMO=y
```

```
diff --git a/drivers/Kconfig b/drivers/Kconfig
index c7a3c412bce1..42821ea09460 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -208,4 +208,8 @@ source "drivers/rk_nand/Kconfig"

 source "drivers/headset_observe/Kconfig"

+source "drivers/demo/Kconfig"
```

```
diff --git a/drivers/Makefile b/drivers/Makefile
index ee62edb593f1..e22bdc6f15ec 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -180,3 +180,5 @@ obj-$(CONFIG_TEE)           += tee/
 obj-$(CONFIG_RK_NAND)          += rk_nand/
 obj-$(CONFIG_RK_HEADSET)       += headset_observe/
 obj-$(CONFIG_RK_FLASH)         += rkflash/
+obj-$(CONFIG_DEMO)     += demo/
```

## 测试代码 bin/mytest
https://blog.csdn.net/bonnshore/article/details/7928673
简单的字符驱动例子包括读写、装载等

cplussharp\linuxdrv-hello\s-test-demo-drv
参考 增加app mmm 再 push


