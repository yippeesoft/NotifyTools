# tnn-mace-tengine-opencl测试

opencl依赖库

```
sudo apt install ocl-icd-libopencl1
sudo apt install opencl-headers
sudo apt install clinfo
sudo apt install ocl-icd-opencl-dev
```



Intel Corporation HD Graphics 530 (rev 06) SDK

```
https://www.intel.com/content/www/us/en/homepage.html 搜索opencl
Intel® SDK for OpenCL™ Applications for Linux* 2019

```

intel   OpenCL™ Runtimes

```
https://github.com/intel/compute-runtime/releases
sudo dpkg -i *.deb
```

emmmm，没搞清楚这一坨到底怎么依赖。。。最后clinfo

```
Number of platforms                               1
  Platform Name                                   Intel(R) CPU Runtime for OpenCL(TM) Applications
  Platform Vendor                                 Intel(R) Corporation
  Platform Version                                OpenCL 2.1 LINUX

```

MACE测试

```
 tools/cmake/cmake-build-host.sh修改-DMACE_ENABLE_OPENCL=ON
  build/cmake-build/host/test/ccbenchmark/mace_cc_benchmark
E mace/mace/core/runtime/opencl/opencl_runtime.cc:379] No GPU device found
Benchmark                                                           Time(ns) Iterations Input(MB/s)     GMACPS
--------------------------------------------------------------------------------------------------------------
MACE_BM_ADDN_2_1_128_128_32_float_CPU                                3607406        278    1162.69       0.00
Segmentation fault (core dumped)
```



