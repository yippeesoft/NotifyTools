# PaddleLite 编译测试



PaddleLite 编译：

=====20200608



NDK版本必须r17c



官方跑分脚本： RK3399



```
/data/local/tmp/result_armv7.txt: 1 file pulled. 0.0 MB/s (753 bytes in 0.081s)

--------------------------------------
PaddleLite Benchmark
Threads=1 Warmup=10 Repeats=30
-- mnasnet               avg = 92.8641 ms
-- mobilenet_v1          avg = 126.4380 ms
-- mobilenet_v2          avg = 94.8814 ms
-- shufflenet_v2         avg = 42.9119 ms
-- squeezenet_v11        avg = 86.0624 ms

Threads=2 Warmup=10 Repeats=30
-- mnasnet               avg = 60.4557 ms
-- mobilenet_v1          avg = 69.6253 ms
-- mobilenet_v2          avg = 58.1339 ms
-- shufflenet_v2         avg = 28.0010 ms
-- squeezenet_v11        avg = 51.5716 ms

Threads=4 Warmup=10 Repeats=30
-- mnasnet               avg = 326.4035 ms
-- mobilenet_v1          avg = 196.6641 ms
-- mobilenet_v2          avg = 321.0813 ms
-- shufflenet_v2         avg = 251.8339 ms
-- squeezenet_v11        avg = 463.0298 ms
```



 

```
/data/local/tmp/result_armv8.txt: 1 file pulled. 0.0 MB/s (753 bytes in 0.083s)

--------------------------------------
PaddleLite Benchmark
Threads=1 Warmup=10 Repeats=30
-- mnasnet               avg = 87.7520 ms
-- mobilenet_v1          avg = 118.9294 ms
-- mobilenet_v2          avg = 90.8487 ms
-- shufflenet_v2         avg = 41.6656 ms
-- squeezenet_v11        avg = 81.9116 ms

Threads=2 Warmup=10 Repeats=30
-- mnasnet               avg = 55.5989 ms
-- mobilenet_v1          avg = 65.4998 ms
-- mobilenet_v2          avg = 53.7413 ms
-- shufflenet_v2         avg = 26.6267 ms
-- squeezenet_v11        avg = 48.5608 ms

Threads=4 Warmup=10 Repeats=30
-- mnasnet               avg = 259.2998 ms
-- mobilenet_v1          avg = 158.2398 ms
-- mobilenet_v2          avg = 251.5639 ms
-- shufflenet_v2         avg = 197.3245 ms
-- squeezenet_v11        avg = 426.7680 ms
```

