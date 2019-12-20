# NCNN  VULKAN 编译测试



NCNN  VULKAN 编译：

​      源码包：20191113

​      基本按照 https://github.com/Tencent/ncnn/wiki/how-to-build#build-for-android 即可。

benchmark 运行结果有些差异：

以下NDK R19编译

INT8 推理优化不一定都优化，如 mobilenet_ssd。

非V版本比R16编译慢···

```
rk3399_all:/data/tmp/ncnn/benchmark # ./benchncnnv 8 1 2
arm mali driver is too old
no vulkan device
loop_count = 8
num_threads = 1
powersave = 2
gpu_device = -1
          squeezenet  min =   84.76  max =   87.63  avg =   85.53
     squeezenet_int8  min =   89.02  max =   94.85  avg =   90.27
           mobilenet  min =  120.17  max =  123.15  avg =  121.53
      mobilenet_int8  min =  140.87  max =  144.52  avg =  142.01
        mobilenet_v2  min =   89.13  max =   91.18  avg =   89.91
        mobilenet_v3  min =   72.91  max =   76.58  avg =   74.67
          shufflenet  min =   46.65  max =   50.36  avg =   47.88
       shufflenet_v2  min =   42.53  max =   43.07  avg =   42.75
             mnasnet  min =   80.41  max =   83.67  avg =   82.02
     proxylessnasnet  min =   97.34  max =  101.28  avg =   99.82
           googlenet  min =  263.22  max =  272.45  avg =  267.49
      googlenet_int8  min =  296.37  max =  298.98  avg =  297.17
            resnet18  min =  258.52  max =  269.70  avg =  264.20
       resnet18_int8  min =  251.81  max =  259.82  avg =  256.14
             alexnet  min =  228.35  max =  236.87  avg =  232.15
               vgg16  min = 1279.23  max = 1292.77  avg = 1287.43
          vgg16_int8  min = 1707.38  max = 1908.52  avg = 1812.94
            resnet50  min =  608.28  max =  614.32  avg =  611.36
       resnet50_int8  min =  585.25  max =  593.12  avg =  588.18
      squeezenet_ssd  min =  205.34  max =  208.60  avg =  207.01
 squeezenet_ssd_int8  min =  259.24  max =  264.01  avg =  261.43
       mobilenet_ssd  min =  247.41  max =  255.21  avg =  251.39
  mobilenet_ssd_int8  min =  274.25  max =  278.55  avg =  276.41
      mobilenet_yolo  min =  571.65  max =  580.09  avg =  576.68
  mobilenetv2_yolov3  min =  299.40  max =  305.40  avg =  302.36
```

```
rk3399_all:/data/tmp/ncnn/benchmark # ./benchncnn 8 1 2
loop_count = 8
num_threads = 1
powersave = 2
gpu_device = -1
          squeezenet  min =   95.98  max =   98.46  avg =   97.02
     squeezenet_int8  min =   97.40  max =   99.33  avg =   98.07
           mobilenet  min =  143.14  max =  147.18  avg =  144.68
      mobilenet_int8  min =  174.73  max =  177.26  avg =  175.73
        mobilenet_v2  min =   99.71  max =  104.22  avg =  100.90
        mobilenet_v3  min =   80.29  max =   83.93  avg =   82.16
          shufflenet  min =   50.20  max =   53.12  avg =   50.87
       shufflenet_v2  min =   46.17  max =   50.61  avg =   47.14
             mnasnet  min =   97.33  max =  100.37  avg =   99.07
     proxylessnasnet  min =  108.67  max =  109.98  avg =  109.45
           googlenet  min =  287.64  max =  293.33  avg =  289.97
      googlenet_int8  min =  346.58  max =  349.36  avg =  347.33
            resnet18  min =  349.62  max =  380.12  avg =  362.40
       resnet18_int8  min =  271.81  max =  277.88  avg =  275.40
             alexnet  min =  282.92  max =  315.53  avg =  297.12
               vgg16  min = 1883.62  max = 1971.19  avg = 1913.53
          vgg16_int8  min = 1982.52  max = 2024.95  avg = 2002.47
            resnet50  min =  757.30  max =  783.01  avg =  772.20
       resnet50_int8  min =  691.63  max =  696.57  avg =  692.98
      squeezenet_ssd  min =  234.39  max =  255.88  avg =  243.37
 squeezenet_ssd_int8  min =  260.12  max =  263.51  avg =  261.85
       mobilenet_ssd  min =  303.66  max =  312.71  avg =  307.91
  mobilenet_ssd_int8  min =  336.13  max =  339.66  avg =  338.17
      mobilenet_yolo  min =  705.60  max =  724.57  avg =  717.45
  mobilenetv2_yolov3  min =  352.96  max =  367.19  avg =  358.19
```



以下 NDK-R16编译

VULKAN 版本在驱动  too old 认为 no vulkan device，速度比不带V编译慢

INT8 推理优化不一定都优化，如 mobilenet_ssd。

```
rk3399_all:/data/tmp/ncnn/benchmark # ./benchncnnv 8 1 2
arm mali driver is too old
no vulkan device
loop_count = 8
num_threads = 1
powersave = 2
gpu_device = -1
          squeezenet  min =   96.82  max =   99.55  avg =   97.58
     squeezenet_int8  min =   97.11  max =   99.28  avg =   98.03
           mobilenet  min =  138.63  max =  142.39  avg =  140.60
      mobilenet_int8  min =  195.28  max =  198.32  avg =  196.29
        mobilenet_v2  min =  105.61  max =  110.19  avg =  107.82
        mobilenet_v3  min =   82.58  max =   87.62  avg =   84.45
          shufflenet  min =   53.03  max =   55.07  avg =   53.72
       shufflenet_v2  min =   47.26  max =   47.88  avg =   47.56
             mnasnet  min =   96.14  max =   97.21  avg =   96.59
     proxylessnasnet  min =  109.85  max =  116.51  avg =  113.52
           googlenet  min =  322.26  max =  327.12  avg =  324.74
      googlenet_int8  min =  356.48  max =  360.53  avg =  358.18
            resnet18  min =  305.26  max =  329.85  avg =  316.61
       resnet18_int8  min =  275.24  max =  285.41  avg =  278.63
             alexnet  min =  292.68  max =  307.08  avg =  299.85
               vgg16  min = 1804.05  max = 1840.25  avg = 1825.08
          vgg16_int8  min = 1940.02  max = 2040.90  avg = 1989.50
            resnet50  min =  742.47  max =  769.87  avg =  752.40
       resnet50_int8  min =  708.30  max =  712.98  avg =  710.08
      squeezenet_ssd  min =  243.32  max =  262.86  avg =  254.75
 squeezenet_ssd_int8  min =  260.01  max =  263.52  avg =  261.74
       mobilenet_ssd  min =  289.12  max =  301.35  avg =  296.93
  mobilenet_ssd_int8  min =  373.68  max =  382.40  avg =  376.72
      mobilenet_yolo  min =  994.75  max = 1018.53  avg = 1001.67
  mobilenetv2_yolov3  min =  362.23  max =  371.01  avg =  366.75
```

```
rk3399_all:/data/tmp/ncnn/benchmark # ./benchncnn 8 1 2
WARNING: linker: /data/tmp/ncnn/benchmark/benchncnn: unsupported flags DT_FLAGS_1=0x8000001
loop_count = 8
num_threads = 1
powersave = 2
gpu_device = -1
          squeezenet  min =   85.61  max =   87.54  avg =   86.54
     squeezenet_int8  min =   86.55  max =   88.80  avg =   87.68
           mobilenet  min =  121.78  max =  123.79  avg =  122.55
      mobilenet_int8  min =  140.65  max =  142.05  avg =  141.24
        mobilenet_v2  min =   90.17  max =   92.71  avg =   91.10
        mobilenet_v3  min =   74.89  max =   77.92  avg =   76.15
          shufflenet  min =   46.88  max =   49.76  avg =   47.58
       shufflenet_v2  min =   45.10  max =   46.74  avg =   46.02
             mnasnet  min =   81.27  max =   86.51  avg =   83.37
     proxylessnasnet  min =   93.32  max =   97.30  avg =   94.79
           googlenet  min =  259.96  max =  265.76  avg =  262.74
      googlenet_int8  min =  293.33  max =  296.65  avg =  294.69
            resnet18  min =  277.00  max =  300.82  avg =  290.19
       resnet18_int8  min =  249.14  max =  253.50  avg =  251.09
             alexnet  min =  227.07  max =  240.81  avg =  231.32
               vgg16  min = 1286.04  max = 1311.48  avg = 1299.73
          vgg16_int8  min = 1891.28  max = 1929.07  avg = 1906.65
            resnet50  min =  618.47  max =  630.80  avg =  623.20
       resnet50_int8  min =  581.18  max =  586.31  avg =  584.17
      squeezenet_ssd  min =  206.32  max =  212.63  avg =  208.78
 squeezenet_ssd_int8  min =  253.22  max =  258.44  avg =  255.38
       mobilenet_ssd  min =  249.05  max =  257.65  avg =  251.97
  mobilenet_ssd_int8  min =  272.19  max =  279.40  avg =  274.26
      mobilenet_yolo  min =  574.98  max =  596.78  avg =  586.56
  mobilenetv2_yolov3  min =  304.19  max =  307.20  avg =  305.61
```







以下是 https://github.com/Tencent/ncnn/benchmark readme.md


Rockchip RK3399 (Cortex-A72 1.8GHz x 2 + Cortex-A53 1.5GHz x 4)
```
rk3399_firefly_box:/data/local/tmp/ncnn/benchmark # ./benchncnn 8 2 2          
loop_count = 8
num_threads = 2
powersave = 2
gpu_device = -1
          squeezenet  min =   52.53  max =   53.64  avg =   53.06
     squeezenet_int8  min =   53.37  max =   55.72  avg =   54.26
           mobilenet  min =   78.53  max =   81.46  avg =   79.53
      mobilenet_int8  min =   56.26  max =   62.04  avg =   58.40
        mobilenet_v2  min =   69.08  max =   69.97  avg =   69.44
          shufflenet  min =   31.57  max =   34.90  avg =   32.84
             mnasnet  min =   56.12  max =   57.29  avg =   56.54
     proxylessnasnet  min =   66.95  max =   67.46  avg =   67.13
           googlenet  min =  185.60  max =  203.72  avg =  191.80
      googlenet_int8  min =  167.17  max =  195.48  avg =  176.84
            resnet18  min =  192.91  max =  205.34  avg =  198.63
       resnet18_int8  min =  156.85  max =  173.24  avg =  162.57
             alexnet  min =  192.74  max =  209.14  avg =  197.55
               vgg16  min =  896.54  max =  947.90  avg =  924.92
          vgg16_int8  min =  974.32  max =  978.45  avg =  976.64
            resnet50  min =  436.12  max =  457.56  avg =  443.29
       resnet50_int8  min =  357.78  max =  389.60  avg =  369.63
      squeezenet_ssd  min =  144.73  max =  156.56  avg =  148.78
 squeezenet_ssd_int8  min =  173.36  max =  188.41  avg =  176.93
       mobilenet_ssd  min =  169.47  max =  195.27  avg =  174.54
  mobilenet_ssd_int8  min =  124.85  max =  140.70  avg =  129.52
      mobilenet_yolo  min =  387.88  max =  428.71  avg =  402.07
    mobilenet_yolov3  min =  409.21  max =  441.15  avg =  423.70

rk3399_firefly_box:/data/local/tmp/ncnn/benchmark # ./benchncnn 8 1 2          
loop_count = 8
num_threads = 1
powersave = 2
gpu_device = -1
          squeezenet  min =   88.84  max =   91.30  avg =   90.01
     squeezenet_int8  min =   81.19  max =   83.46  avg =   81.69
           mobilenet  min =  134.79  max =  142.97  avg =  136.94
      mobilenet_int8  min =  105.89  max =  109.47  avg =  107.22
        mobilenet_v2  min =  106.92  max =  119.60  avg =  109.01
          shufflenet  min =   47.03  max =   48.43  avg =   47.69
             mnasnet  min =   90.78  max =   93.82  avg =   92.34
     proxylessnasnet  min =  109.38  max =  116.27  avg =  110.83
           googlenet  min =  325.96  max =  340.11  avg =  333.55
      googlenet_int8  min =  280.99  max =  286.43  avg =  283.21
            resnet18  min =  316.71  max =  328.74  avg =  321.68
       resnet18_int8  min =  253.65  max =  267.48  avg =  258.11
             alexnet  min =  310.41  max =  319.24  avg =  312.40
               vgg16  min = 1441.65  max = 1481.38  avg = 1468.75
          vgg16_int8  min = 1502.82  max = 1521.61  avg = 1512.19
            resnet50  min =  681.50  max =  692.14  avg =  686.59
       resnet50_int8  min =  558.08  max =  567.24  avg =  561.13
      squeezenet_ssd  min =  206.77  max =  216.37  avg =  210.85
 squeezenet_ssd_int8  min =  234.60  max =  245.13  avg =  241.38
       mobilenet_ssd  min =  271.13  max =  278.40  avg =  273.75
  mobilenet_ssd_int8  min =  216.88  max =  218.81  avg =  217.94
      mobilenet_yolo  min =  627.36  max =  636.86  avg =  632.40
    mobilenet_yolov3  min =  669.06  max =  682.47  avg =  676.11

rk3399_firefly_box:/data/local/tmp/ncnn/benchmark # ./benchncnn 8 4 1          
loop_count = 8
num_threads = 4
powersave = 1
gpu_device = -1
          squeezenet  min =   58.57  max =   63.54  avg =   60.35
     squeezenet_int8  min =   62.79  max =   70.43  avg =   64.09
           mobilenet  min =   77.82  max =   95.34  avg =   80.56
      mobilenet_int8  min =   63.26  max =   78.81  avg =   67.81
        mobilenet_v2  min =   72.23  max =   84.33  avg =   74.97
          shufflenet  min =   41.25  max =   42.31  avg =   41.78
             mnasnet  min =   64.83  max =   82.47  avg =   67.73
     proxylessnasnet  min =   73.91  max =   85.34  avg =   76.67
           googlenet  min =  206.27  max =  280.66  avg =  227.77
      googlenet_int8  min =  192.79  max =  201.67  avg =  194.85
            resnet18  min =  203.68  max =  220.28  avg =  208.50
       resnet18_int8  min =  181.08  max =  193.67  avg =  183.65
             alexnet  min =  204.49  max =  208.71  avg =  206.48
               vgg16  min = 1031.40  max = 1059.07  avg = 1043.01
          vgg16_int8  min = 1173.33  max = 1192.29  avg = 1182.97
            resnet50  min =  410.29  max =  424.84  avg =  418.18
       resnet50_int8  min =  389.76  max =  398.02  avg =  392.88
      squeezenet_ssd  min =  169.58  max =  206.14  avg =  180.93
 squeezenet_ssd_int8  min =  199.68  max =  213.47  avg =  203.46
       mobilenet_ssd  min =  157.87  max =  173.44  avg =  162.57
  mobilenet_ssd_int8  min =  121.86  max =  133.69  avg =  125.92
      mobilenet_yolo  min =  349.75  max =  379.45  avg =  357.83
    mobilenet_yolov3  min =  363.76  max =  380.45  avg =  371.56

rk3399_firefly_box:/data/local/tmp/ncnn/benchmark # ./benchncnn 8 1 1          
loop_count = 8
num_threads = 1
powersave = 1
gpu_device = -1
          squeezenet  min =  165.76  max =  171.54  avg =  167.61
     squeezenet_int8  min =  172.42  max =  183.19  avg =  174.43
           mobilenet  min =  245.50  max =  253.09  avg =  246.99
      mobilenet_int8  min =  221.14  max =  225.25  avg =  222.41
        mobilenet_v2  min =  190.55  max =  194.63  avg =  192.44
          shufflenet  min =   93.85  max =   98.10  avg =   95.70
             mnasnet  min =  174.12  max =  177.20  avg =  175.25
     proxylessnasnet  min =  213.46  max =  223.07  avg =  215.19
           googlenet  min =  667.97  max =  673.11  avg =  670.70
      googlenet_int8  min =  577.49  max =  579.45  avg =  578.19
            resnet18  min =  619.58  max =  626.98  avg =  622.85
       resnet18_int8  min =  527.11  max =  534.05  avg =  528.98
             alexnet  min =  762.35  max =  768.60  avg =  764.67
               vgg16  min = 3265.98  max = 3288.08  avg = 3279.45
          vgg16_int8  min = 3113.77  max = 3157.23  avg = 3134.39
            resnet50  min = 1321.07  max = 1341.97  avg = 1329.78
       resnet50_int8  min = 1187.20  max = 1195.61  avg = 1190.90
      squeezenet_ssd  min =  442.01  max =  457.50  avg =  450.00
 squeezenet_ssd_int8  min =  481.22  max =  501.44  avg =  488.83
       mobilenet_ssd  min =  497.80  max =  503.22  avg =  500.30
  mobilenet_ssd_int8  min =  447.33  max =  453.04  avg =  448.56
      mobilenet_yolo  min = 1115.70  max = 1121.13  avg = 1117.58
    mobilenet_yolov3  min = 1178.09  max = 1186.41  avg = 1181.39
```

Rockchip RK3288 (Cortex-A17 1.8GHz x 4)
```
root@rk3288:/data/local/tmp/ncnn # ./benchncnn 8 4 0 
loop_count = 8
num_threads = 4
powersave = 0
      squeezenet  min =   51.43  max =   74.02  avg =   55.91
       mobilenet  min =  102.06  max =  125.67  avg =  106.02
    mobilenet_v2  min =   80.09  max =   99.23  avg =   85.40
      shufflenet  min =   34.91  max =   35.75  avg =   35.25
       googlenet  min =  181.72  max =  252.12  avg =  210.67
        resnet18  min =  198.86  max =  240.69  avg =  214.87
         alexnet  min =  154.68  max =  208.60  avg =  168.75
           vgg16  min = 1019.49  max = 1231.92  avg = 1129.09
  squeezenet-ssd  min =  133.38  max =  241.11  avg =  167.77
   mobilenet-ssd  min =  156.71  max =  216.70  avg =  175.31
  mobilenet-yolo  min =  396.78  max =  482.60  avg =  433.34

root@rk3288:/data/local/tmp/ncnn # ./benchncnn 8 1 0
loop_count = 8
num_threads = 1
powersave = 0
      squeezenet  min =  137.93  max =  140.76  avg =  138.71
       mobilenet  min =  244.01  max =  248.27  avg =  246.24
    mobilenet_v2  min =  177.94  max =  181.57  avg =  179.24
      shufflenet  min =   77.61  max =   78.30  avg =   77.94
       googlenet  min =  548.75  max =  559.40  avg =  553.00
        resnet18  min =  493.66  max =  510.55  avg =  500.37
         alexnet  min =  564.20  max =  604.87  avg =  581.30
           vgg16  min = 2425.03  max = 2447.25  avg = 2433.38
  squeezenet-ssd  min =  298.26  max =  304.67  avg =  302.00
   mobilenet-ssd  min =  465.65  max =  473.33  avg =  469.86
  mobilenet-yolo  min =  997.95  max = 1012.45  avg = 1002.32
```

