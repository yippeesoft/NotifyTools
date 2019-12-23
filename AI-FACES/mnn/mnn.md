# MNN记录

## 说明

| 名称 | **mnn**                        |
| ---- | ------------------------------ |
| 网址 | https://github.com/alibaba/MNN |
|      |                                |

## caffe_retinaface

 https://github.com/xindongzhang/MNN-APPLICATIONS

NDK R20编译

修改 MNN-APPLICATIONS\applications\retinaface\caffe\jni caffe_retinaface.cpp

int forward = MNN_FORWARD_VULKAN;
	//int forward = MNN_FORWARD_CPU;

VULKAN版本比CPU版本慢··NDK版本不同也会有影响。

```
rk3399_all:/data/tmp/mnn # ./caffe_retinafacev
duration: 0.040168
aaa3
final result 3
rk3399_all:/data/tmp/mnn # ./caffe_retinaface
duration: 0.023822
aaa3
final result 3
```



## MNN Benchmark  

git 20191126版本 c36ad97cd8f8b3dff840d57a1630a4fc71bb7ce9

不支持 Metal  OpenGL

VULKAN效果看不出优势

OPENCL VULKAN对于模型似乎都有不支持的。如Don't support type 68。

```
https://www.yuque.com/mnn/en/tool_benchmark 
./benchmark.out models_folder [loop_count] [forwardtype]
forwardtype is in these options: 0->CPU，1->Metal，3->OpenCL，6->OpenGL，7->Vulkan.
```

```
rk3399_all:/data/tmp/mnn # ./benchmark.out ./models/ 4 7
MNN benchmark
Forward type: **Vulkan** thread=4** precision=2
--------> Benchmarking... loop = 4
[ - ] inception-v3.mnn            max =  686.755ms  min =  611.842ms  avg =  652.360ms
[ - ] mobilenet-v1-1.0.mnn        max =  104.824ms  min =   95.746ms  avg =   99.331ms
[ - ] MobileNetV2_224.mnn         max =  112.035ms  min =  108.230ms  avg =  109.883ms
Vulkan don't support 68, Reduction: resnet_v2_50/pool5
[ - ] resnet-v2-50.mnn            max =  436.363ms  min =  418.711ms  avg =  428.666ms
Vulkan don't support 2, ArgMax: ArgMax
[ - ] SqueezeNetV1.0.mnn          max =  110.650ms  min =  109.375ms  avg =  109.895ms
```



```
130|rk3399_all:/data/tmp/mnn # ./benchmark.out ./models/ 4 3
MNN benchmark
Forward type: **OpenCL** thread=4** precision=2
--------> Benchmarking... loop = 4
[ - ] inception-v3.mnn            max =  692.190ms  min =  686.771ms  avg =  689.971ms
[ - ] mobilenet-v1-1.0.mnn        max =   48.282ms  min =   44.475ms  avg =   47.223ms
[ - ] MobileNetV2_224.mnn         max =   48.867ms  min =   47.519ms  avg =   47.980ms
Don't support type 68, resnet_v2_50/pool5
[ - ] resnet-v2-50.mnn            max =  269.285ms  min =  268.298ms  avg =  268.747ms
Don't support type 2, ArgMax
[ - ] SqueezeNetV1.0.mnn          max =  109.414ms  min =   96.062ms  avg =   99.548ms
```



```
134|rk3399_all:/data/tmp/mnn # ./benchmark.out ./models/ 4 0
MNN benchmark
Forward type: **CPU** thread=4** precision=2
--------> Benchmarking... loop = 4
[ - ] inception-v3.mnn            max =  628.709ms  min =  624.886ms  avg =  626.775ms
[ - ] mobilenet-v1-1.0.mnn        max =   89.497ms  min =   86.043ms  avg =   86.975ms
[ - ] MobileNetV2_224.mnn         max =   56.893ms  min =   55.031ms  avg =   56.023ms
[ - ] resnet-v2-50.mnn            max =  440.988ms  min =  435.824ms  avg =  438.777ms
[ - ] SqueezeNetV1.0.mnn          max =  111.184ms  min =  109.775ms  avg =  110.233ms
rk3399_all:/data/tmp/mnn # ls
WARNING: linker: Warning: unable to normalize "pwd"
WARNING: linker: Warning: unable to normalize ""
benchmark.out libMNN.so libMNN_Arm82.so libMNN_CL.so libMNN_Vulkan.so models
```





## 编译

|             | https://github.com/alibaba/MNN/issues/156  https://github.com/piaobuliao |
| ----------- | ------------------------------------------------------------ |
|             | cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release ..<br/>nmake |
|             | https://github.com/alibaba/MNN/issues/443  https://github.com/Martyn10 修改 source/core/session.hpp |
|             | class MNN_PUBLIC Session : public NonCopyable{`  instead of  `class MNN_PUBLIC Session{  //不然会提示 尝试引用已删除的函数 |
|             |                                                              |
|             | MNN\tools\cpp CMakeLists.txt 注释 checkInvalidValue          |
|             |                                                              |
|             | 自从开源编译以来，比玩游戏找攻略好玩多了···                  |
|             |                                                              |
| 官方文档    | https://www.yuque.com/mnn/cn/build_windows                   |
| 问题        | 3rd_party\flatbuffers需要生成flatc LINUX下比较简单           |
|             | 无法将“..\..\3rd_party\flatbuffers\tmp\flatc.exe”项识别      |
| WINDOWS编译 | 参照 https://github.com/dvidelabs/flatcc#building VS2017     |
|             | x64 Native Tools Command Prompt for VS 2017                  |
|             | cmake .. -G "Visual Studio 15" -DCMAKE_BUILD_TYPE=Release    |
|             | cmake --build . --target --config Release                    |
| 问题        | flatbuffers\util.h : warning C4819: 该文件包含不能在当前代码页(936)中表示的字符。请将该文件保存为 Unicode |
|             | 直接记事本打开另存为unicode；将flatc.exe复制到3rd_party\flatbuffers\tmp\flatc.exe |
|             |                                                              |
| 问题        | cmake版本必须 3.15以上 VS2019带 VS2017会Unknown CMake command "target_link_options". |
| 解决        | 带路径运行高版本cmake                                        |
|             | y:\tmp\mnn\source\core\DirectedAcyclicGraph.hpp              |
|             |                                                              |



