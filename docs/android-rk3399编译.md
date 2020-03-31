# 					android bild

环境

​		ubuntu 18.04 android 7.1 rk3399

​       build-rk3399-all.sh

问题：

​      Assertion `cnt < (sizeof (_nl_value_type_LC_TIME) / sizeof (_nl_value_type_LC_TIME[0]))*' faile*

​     **export LC_ALL=C**



​      Out of memory error Java heap space.

**export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx6g"**

**./prebuilts/sdk/tools/jack-admin stop-server**

**./prebuilts/sdk/tools/jack-admin start-server**

nano *tools/jack-admin b/tools/jack-admin*

JACK_SERVER_COMMAND="java -XX:MaxJavaStackTraceDepth=-1 -Djava.io.tmpdir=$TMPDIR $JACK_SERVER_VM_ARGUMENTS  **-Xmx**6g

​      编译速度

​     **注释掉 make clean 等部分**