

# MTCNN

## 说明

| 名称   | MTCNN                                                        |
| ------ | ------------------------------------------------------------ |
| 网址   | https://github.com/deepinsight/insightface                   |
| 模型库 | det*.                                                        |
| 目的   | 转换MTCNN模型到MNN测试。网上均多3个模型库版本。              |
| 问题   | MXNET MTCNN模型库 DET4转换ONNX失败；CAFFE模型转换为MMN模型成功，但有反馈说结果对不上 |





```
https://github.com/hurricanemad/MTCNN_SHELL
m_matNormalizeMat.size:[17 x 12]
OpenCV Error: Assertion failed (0 <= roi.x && 0 <= roi.width
```



```
https://github.com/leonardozcm/MTCNN-with-Caffe
改用该版本，运行基本正常，但是模型库和foreverYoungGitHub/MTCNN的不一样
prototxt差不多，但是caffemodel差异较大。

```





```
https://github.com/foreverYoungGitHub/MTCNN star比较多
但是caffe库似乎比较旧
 caffe::SetMode(caffe::CPU 会提示找不到函数等
```


```
曲线救国 CAFFE 编译 环境 docker ubuntu 16.04 
https://github.com/BVLC/caffe
参考：http://caffe.berkeleyvision.org/install_apt.html
https://github.com/BVLC/caffe/wiki/Commonly-encountered-build-issues

diff Makefile.config Makefile.config.example 
8c8
< CPU_ONLY := 1
---
> # CPU_ONLY := 1
23c23
< OPENCV_VERSION := 3
---
> # OPENCV_VERSION := 3
97,98c97,98
< INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial/
< LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu/hdf5/serial /usr/local/lib/x86_64-linux-gnu/
---
> INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include
> LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib

diff --git a/Makefile b/Makefile 主要解决std c++11问题。只在LINUX下加，make runtest一样会c++ 11失败。

index b7660e8..ec9fed1 100644
--- a/Makefile
+++ b/Makefile
@@ -260,6 +260,8 @@ endif
 
 # Linux
 ifeq ($(LINUX), 1)
+        NVCCFLAGS += -std=c++11
+       CXXFLAGS += -std=c++11
        CXX ?= /usr/bin/g++
        GCCVERSION := $(shell $(CXX) -dumpversion | cut -f1,2 -d.)
        # older versions of gcc are too dumb to build boost with -Wuninitalized
@@ -421,11 +423,11 @@ CXXFLAGS += -MMD -MP
 
 # Complete build flags.
 COMMON_FLAGS += $(foreach includedir,$(INCLUDE_DIRS),-I$(includedir))
-CXXFLAGS += -pthread -fPIC $(COMMON_FLAGS) $(WARNINGS)
-NVCCFLAGS += -ccbin=$(CXX) -Xcompiler -fPIC $(COMMON_FLAGS)
+CXXFLAGS += -pthread -fPIC $(COMMON_FLAGS) $(WARNINGS) -std=c++11
+NVCCFLAGS += -ccbin=$(CXX) -Xcompiler -fPIC $(COMMON_FLAGS) -std=c++11
 # mex may invoke an older gcc that is too liberal with -Wuninitalized
 MATLAB_CXXFLAGS := $(CXXFLAGS) -Wno-uninitialized
-LINKFLAGS += -pthread -fPIC $(COMMON_FLAGS) $(WARNINGS)
+LINKFLAGS += -pthread -fPIC $(COMMON_FLAGS) $(WARNINGS) -std=c++11
 
 USE_PKG_CONFIG ?= 0
 ifeq ($(USE_PKG_CONFIG), 1)
```



