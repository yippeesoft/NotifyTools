---
title: android 编译
date: 2022-02-28
type: 软件
tags: android, 开源, 软件,应用,编译,rockchip
---

# android rockchip 编译 笔记

### 编译命令
```
模块编译:
source build/envsetup.sh 
lunch xx
mmm frameworks/base/services 
或者
cd frameworks/base/services 
mm

mmm frameworks/base/services 2>&1 | tee build.log
```
```
android11
make services
```
[Ninja提升编译速度的方法-Android10.0编译系统](https://blog.csdn.net/mafei852213034/article/details/117808410)
```
time prebuilts/build-tools/linux-x86/bin/ninja -v -d keepdepfile XXX -f out/combined-aosp_arm.ninja -w dupbuild=err
```

build/make/envsetup.sh
```shell
function qninja()
{
    local cmdline="time prebuilts/build-tools/linux-x86/bin/ninja -v -d keepdepfile $@ -f out/combined-aosp_arm.ninja -w dupbuild=warn"
    echo $cmdline
    $cmdline

```

[使用 Ninja 提升模块编译速度](https://blog.csdn.net/shensky711/article/details/103480730/)
[使用ninja命令提高单模块编译效率](https://www.cnblogs.com/szsky/articles/10812959.html)
[[AOSP][Android]查看某个模块编译原始指令](https://blog.csdn.net/u014175785/article/details/115319550)
```powershell
使用前需把对应模块编译一遍，用于生产 ninja 文件（全编或 mmm 都可以）
全编后，生成的 ninja 文件为：./out/combined-[TARGET-PRODUCT].ninja
mmm 编译后，生成的 ninja 文件为：./out/combined-[TARGET-PRODUCT]-_[path_to_your_module_makefile].ninja，比如：./out/combined-aosp_walleye-_packages_apps_Launcher3_Android.mk.ninja
如果修改了 Android.mk 或 Android.bp，需使用传统的 make 命令进行编译以重新生成包含新依赖规则的 ninja 文件
可以把 ninja 放到 PATH 环境变量中，这样就不用每次都敲 ./prebuilts/build-tools/linux-x86/bin/ninja 这个路径了
4. 最后
为 Launcher 和 SystemUI 准备一份开箱即用的指令，尽情玩耍吧~

使用方法

./prebuilts/build-tools/linux-x86/bin/ninja -f out/combined-xxx.ninja相当于make，xxx为对应的lunch项，

Launcher：

./prebuilts/build-tools/linux-x86/bin/ninja -f out/combined-qssi-_packages_apps_Launcher3_Android.mk.ninja Launcher3QuickStep
1
SystemUI：

./prebuilts/build-tools/linux-x86/bin/ninja -f out/combined-qssi-_frameworks_base_packages_SystemUI_Android.mk.ninja SystemUI
```

### 编译错误

#### android 7.1
1.KS 密钥库使用专用格式 迁移到行业标准格式 PKCS12。
```
sudo nano /etc/java-8-openjdk/security/java.security
删除 jdk.tls.disabledAlgorithms 的 TLSv1, TLSv1.1 
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server
```

### andorid studio 工程 导入 调试
[android源码调试实战技能及阅读技巧](https://www.sohu.com/a/501834001_121119002)
[AndroidStudio优雅的导入android源码](https://blog.csdn.net/hbdatouerzi/article/details/86561228)
1. ssource build/envsetup.sh ; lunch xx ; make idegen
2. sudo ./development/tools/idegen/idegen.sh
3. (本人用的linux samba映射到windows as) adnroid.iml sourceFolder 全部改成 excludeFolder，Project Structure面板add content root 增加对应源码,附加到进程进行调试.初步测试录音机/设置等
4. 
### 低内存补丁
[低内存补丁](https://github.com/masemoel/build_soong_legion-r)
build/soong/
```diff
Specify heap size for metalava for R
filiprrs: This is needed on systems with 8GB physical ram.
Compiling using a single job is recommended.

java/droiddoc.go
@@ -1474,6 +1474,7 @@ func metalavaCmd(ctx android.ModuleContext, rule *android.RuleBuilder, javaVersi

	cmd.BuiltTool(ctx, "metalava").
		Flag(config.JavacVmFlags).
+		Flag("-J-Xmx3112m").
		FlagWithArg("-encoding ", "UTF-8").
		FlagWithArg("-source ", javaVersion.String()).
		FlagWithRspFileInputList("@", srcs).
```

```diff
Tune java compiler flags for low ram systems
* Reduce max heap size
 java/config/config.go 
@@ -64,7 +64,7 @@ const (
func init() {
	pctx.Import("github.com/google/blueprint/bootstrap")

-	pctx.StaticVariable("JavacHeapSize", "2048M")
+	pctx.StaticVariable("JavacHeapSize", "1024M")
	pctx.StaticVariable("JavacHeapFlags", "-J-Xmx${JavacHeapSize}")
	pctx.StaticVariable("DexFlags", "-JXX:OnError='cat hs_err_pid%p.log' -JXX:CICompilerCount=6 -JXX:+UseDynamicNumberOfGCThreads")

java/config/makevars.go 
@@ -42,7 +42,7 @@ func makeVarsProvider(ctx android.MakeVarsContext) {
	ctx.Strict("COMMON_JDK_FLAGS", "${CommonJdkFlags}")

	ctx.Strict("DX", "${D8Cmd}")
-	ctx.Strict("DX_COMMAND", "${D8Cmd} -JXms16M -JXmx2048M")
+	ctx.Strict("DX_COMMAND", "${D8Cmd} -JXms16M -JXmx1024M")
	ctx.Strict("R8_COMPAT_PROGUARD", "${R8Cmd}")

	ctx.Strict("TURBINE", "${TurbineJar}")
```

### magisk/xposed 系列
找不到rk的bootloader驱动,更改pid/UID又有win10驱动验证问题.使用rk工具刷入.
[XposedBridge Development tutorial](https://github.com/rovo89/XposedBridge/wiki/Development-tutorial)
[Xposed的框架的使用]https://blog.csdn.net/u012417380/article/details/55254369

1. xposed 已经不支持新android
2. edxposed:基本无维护，依赖 magisk riru 25.4.4。但是edxposed manager 找不到edxposed framework.
3. lsposed: 
	3.1   magisk 24 + lsposed-zygisk 版本，和 MagiskHidePropsConf 配置重启几次后magisk启动失败找不到 Landroid/window/SplashScreenView;
	3.2 magisk 24 + lsposed-riru+riru26
4. 编写模块 (好像回到了n年前试xposed...)
5. lsposed hook进程要一个个多选

### git `git` repo
#### git submodules 同步最好是 git clone --recursive prj_url。
用 git submodules init ;git submodules update 经常会有问题

```
repo forall -c 'CMD' //repo遍历命令
repo forall -c 'echo $REPO_PROJECT; git diff --shortstat tagA tagB'
git remote -v | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//' 获得项目名
git log --pretty=oneline  --author='AA' --grep="JRA-224:" 日志过滤作者,单行显示
git show  xx46a2ef5627xx 某条提交记录
```

#### RPC failed
[git error: RPC failed; curl 18 transfer closed with outstanding read data remaining error: 7777 bytes of body are still expected](https://www.cnblogs.com/whycai/p/15500655.html)
老外的工具容错性实在... 大佬们都不用重新clone的么..
```shell
关闭core.compression
git config --global core.compression 0
depth下载最近一次提交
git clone --depth 1 url
然后获取完整库
git fetch --unshallow
pull一下查看状态
git pull --all
```
配置git的最低速度和最低速度时间：
```shell
git config --global http.lowSpeedLimit 0 
git config --global http.lowSpeedTime 999999 #单位/秒
```

#### git拉取冲突
[Pulling is not possible because you have unmerged files](https://blog.csdn.net/mango_love/article/details/87261529)
基本按照git的提示执行,解决冲突后再次合并提交. 应该有个push前检查冲突,需要合并再push的设置的.
