# TVM Insightface测试结果

## 说明  失败

| 名称 | **insightface** Deploy Face Recognition Model via TVM        |
| ---- | ------------------------------------------------------------ |
| 网址 | https://github.com/deepinsight/insightface/wiki/Tutorial:-Deploy-Face-Recognition-Model-via-TVM |
|      |                                                              |
|      | https://github.com/MirrorYuChen/tvm_insightface face recognize based on tvm |

## 结果

| python3 compile.py                                           |      |
| ------------------------------------------------------------ | ---- |
| Cannot find config for target=llvm -mcpu=broadwell           |      |
|                                                              |      |
| python3 deploy.py                                            |      |
| (1, 3, 112, 112)<br/>Illegal instruction                     |      |
|                                                              |      |
| TVM 环境 DOCKER                                              |      |
| https://docs.tvm.ai/install/docker.html                      |      |
| 然后编译 tvm，安装python                                     |      |
|                                                              |      |
| 直接 https://docs.tvm.ai/install/from_source.html            |      |
| 会 vta/include/vta/hw_spec.h VTA_LOG_BUS_WIDTH 找不到定义<br/>MAKEFILE.CFG屏蔽VTA。 |      |
| 最终还是和docker环境一样出错。                               |      |
|                                                              |      |
|                                                              |      |

| 顺便补下DOCKER PY什么的                                      |      |
| ------------------------------------------------------------ | ---- |
| //源码开始<br/> https://docs.tvm.ai/install/from_source.html<br/> <br/> docker pull hub.c.163.com/library/ubuntu:16.04 <br/> <br/> docker run -ti ubuntu bash<br/> <br/> apt-get updte <br/> <br/> apt-get install nano <br/> <br/> nano /etc/apt/sources.list<br/> <br/>deb http://mirrors.163.com/ubuntu/ xenial main restricted universe multiverse<br/>deb http://mirrors.163.com/ubuntu/ xenial-security main restricted universe multiverse<br/>deb http://mirrors.163.com/ubuntu/ xenial-updates main restricted universe multiverse<br/>deb http://mirrors.163.com/ubuntu/ xenial-backports main restricted universe multiverse<br/>deb http://mirrors.163.com/ubuntu/ xenial-proposed main restricted universe multiverse<br/><br/><br/>apt-get install python3 git<br/><br/>curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py   # 下载安装脚本<br/><br/>python3 get-pip.py    # 运行安装脚本。<br/><br/>pip3 install numpy -i https://pypi.tuna.tsinghua.edu.cn/simple<br/><br/>````<br/>git clone --recursive https://github.com/apache/incubator-tvm tvm<br/><br/>中间 PIP3 APT-GET 缺啥补啥吧<br/><br/>vta/include/vta/hw_spec.h VTA_LOG_BUS_WIDTH 找不到定义<br/>MAKEFILE.CFG屏蔽VTA。 <br/><br/>最后终于得到so。安装python。<br/><br/>但是  https://github.com/MirrorYuChen/tvm_insightface<br/>python compile.py 崩溃 |      |
|                                                              |      |
|                                                              |      |
|                                                              |      |
|                                                              |      |
|                                                              |      |
|                                                              |      |





