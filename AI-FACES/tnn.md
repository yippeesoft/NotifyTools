# TNN 编译测试



TNN  编译：

=====20200611

 //几个带linux字样的编译sh里面都是 arm = ON···



官方跑分脚本： RK3399



```
./benchmark_models.sh -32

compute.cc:409: error: undefined reference to 'ConvFloatO4'
。。。
recipe for target 'libTNN.so' failed
```



```
 ./benchmark_models.sh  -t CPU
 
 arm_concat_layer_acc.cc][Line 161] Error: invalid inputs count
 default_network.cc][Line 348] Forward error code: 0x3000 msg: Concat layer's inputs size must >= 2, exit
 ....
 
 benchmark device: ARM 

inception_v3.tnnproto                         time cost: min = 2149.108 ms  |  max = 2187.857 ms  |  avg = 2166.143 ms 
mobilenet_v1.tnnproto                         time cost: min = 108.748  ms  |  max = 111.701  ms  |  avg = 110.149  ms 
mobilenet_v2.tnnproto                         time cost: min = 85.420   ms  |  max = 88.145   ms  |  avg = 86.896   ms 
quant_inception_v3.tnnproto                   time cost: min = 1101.279 ms  |  max = 1105.070 ms  |  avg = 1102.798 ms 
quant_mobilenet_v1.tnnproto                   time cost: min = 70.581   ms  |  max = 71.084   ms  |  avg = 70.803   ms 
quant_mobilenet_v2.tnnproto                   time cost: min = 55.456   ms  |  max = 55.967   ms  |  avg = 55.649   ms 
quant_resnet50.tnnproto                       time cost: min = 449.122  ms  |  max = 455.898  ms  |  avg = 452.240  ms 
quant_squeezenet_v1.0.tnnproto                time cost: min = 105.784  ms  |  max = 106.418  ms  |  avg = 106.013  ms 
quant_squeezenet_v1.1.tnnproto                time cost: min = 46.444   ms  |  max = 46.868   ms  |  avg = 46.632   ms 
resnet50.tnnproto                             time cost: min = 572.050  ms  |  max = 643.718  ms  |  avg = 597.025  ms 
shufflenet_v2_x0.5.tnnproto                   time cost: min = 13.339   ms  |  max = 15.141   ms  |  avg = 14.293   ms 
squeezenet_v1.0.tnnproto                      time cost: min = 146.498  ms  |  max = 147.415  ms  |  avg = 146.806  ms 
squeezenet_v1.1.tnnproto                      time cost: min = 64.746   ms  |  max = 66.737   ms  |  avg = 65.654   ms 
yolov3-tiny.tnnproto                          time cost: min = 264.702  ms  |  max = 320.810  ms  |  avg = 288.280  ms 
```



 

```
./benchmark_models.sh


arm_concat_layer_acc.cc][Line 161] Error: invalid inputs count
default_network.cc][Line 348] Forward error code: 0x3000 msg: Concat layer's inputs size must >= 2, exit
。。。。
opencl_wrapper.cc][Line 161] load func (clEnqueueAcquireGLObjects) from (libOpenCL.so) failed!
。。。

test.cc][Line 270] create instance failed: code: 0x9001 msg: load opencl library falied! 
/data/local/tmp/tnn-benchmark/benchmark_models_result.txt: 1 file pulled. 0.0 MB/s (1771 bytes in 0.082s)
DMB5390

benchmark device: ARM 

inception_v3.tnnproto                         time cost: min = 2139.896 ms  |  max = 2181.796 ms  |  avg = 2160.137 ms 
mobilenet_v1.tnnproto                         time cost: min = 110.350  ms  |  max = 112.621  ms  |  avg = 111.448  ms 
mobilenet_v2.tnnproto                         time cost: min = 83.836   ms  |  max = 86.423   ms  |  avg = 85.430   ms 
quant_inception_v3.tnnproto                   time cost: min = 1079.295 ms  |  max = 1081.563 ms  |  avg = 1079.909 ms 
quant_mobilenet_v1.tnnproto                   time cost: min = 70.891   ms  |  max = 72.665   ms  |  avg = 71.400   ms 
quant_mobilenet_v2.tnnproto                   time cost: min = 55.334   ms  |  max = 55.713   ms  |  avg = 55.464   ms 
quant_resnet50.tnnproto                       time cost: min = 439.907  ms  |  max = 453.361  ms  |  avg = 442.018  ms 
quant_squeezenet_v1.0.tnnproto                time cost: min = 104.758  ms  |  max = 105.320  ms  |  avg = 104.961  ms 
quant_squeezenet_v1.1.tnnproto                time cost: min = 46.218   ms  |  max = 46.566   ms  |  avg = 46.349   ms 
resnet50.tnnproto                             time cost: min = 641.350  ms  |  max = 718.910  ms  |  avg = 690.939  ms 
shufflenet_v2_x0.5.tnnproto                   time cost: min = 13.598   ms  |  max = 15.456   ms  |  avg = 14.491   ms 
squeezenet_v1.0.tnnproto                      time cost: min = 146.415  ms  |  max = 149.749  ms  |  avg = 147.292  ms 
squeezenet_v1.1.tnnproto                      time cost: min = 64.995   ms  |  max = 66.100   ms  |  avg = 65.358   ms 
yolov3-tiny.tnnproto                          time cost: min = 306.615  ms  |  max = 371.575  ms  |  avg = 339.631  ms 

benchmark device: OPENCL 

```

