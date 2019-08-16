# Insightface测试结果

## 说明

| 名称   | **insightface**                                              |
| ------ | ------------------------------------------------------------ |
| 网址   | https://github.com/deepinsight/insightface                   |
| 模型库 | LResNet100E-IR,ArcFace@ms1m-refine-v2 model-r100-ii.zip<br> 99.77% |
|        |                                                              |

## 结果

| 数据来源       | https://github.com/honghuCode/mobileFacenet-ncnn lfw-112X112.zip pairs_1.txt |
| -------------- | ------------------------------------------------------------ |
| 总条数         | 5474                                                         |
| 检测数         | 5456                                                         |
| 最大错误相似度 | -1 0.3143018                                                 |
| 最小正确相似度 | 1  -0.012074059                                              |
| 误差           | 正确数据中取 0.31阈值有32条识别错误                          |
| 正确率         | (5456-32)/5456=0.9941 <br>(5456-32)/5474=0.9908              |

| 数据来源       | [pairs_label.txt](https://github.com/deepinsight/insightface/blob/master/recognition/data/lfw/pairs_label.txt) <br>lfw.tgz |
| -------------- | ------------------------------------------------------------ |
| 总条数         | 6000                                                         |
| 检测数         | 5995                                                         |
| 最大错误相似度 | -1 0.2867911                                                 |
| 最小正确相似度 | 1 -0.22074395                                                |
| 误差           | 正确数据中取 0.285阈值有194条识别错误                        |
| 正确率         | (5995-194)/6000=0.9668                                       |

| 运行类型                                                     | ctx = mx.cpu() i7-8750   model.get_feature |
| ------------------------------------------------------------ | ------------------------------------------ |
| 次数                                                         | 100/1000                                   |
| 耗时                                                         | 41350ms/449512 ms                          |
|                                                              |                                            |
| 运行类型                                                     | GTX 1050 ctx = mx.gpu()                    |
| 耗时                                                         | 4284 ms/30066 ms                           |
|                                                              |                                            |
| LResNet100E-IR                                               | 5749文件 497773 ms                         |
| Y1-MODEL https://github.com/deepinsight/insightface/issues/214 | 5749  556281ms                             |

| 运行类型 | GTX 1050 ctx = mx.gpu() lfw                                  |
| -------- | ------------------------------------------------------------ |
| 测试方式 | 提取lfw所有目录下首张图片的特征值（两个文件检测失败），再交叉比对，排除同名文件，列出最大相似度文件。 |
| 测试数目 | 文件数：5747；交叉次数：33028009；耗时：469692 ms            |
|          | ***改了个三线程版本 33016515 ；耗时 931294 ms***             |
| 结果     | 取大于0.5且非同名文件共152                                   |
|          | **懒得去数下面的问题人数了**                                 |
| 问题     | 发现同人不同名文件。<br>http://vis-www.cs.umass.edu/lfw/ 如：<br>[Carlos_Beltran](http://vis-www.cs.umass.edu/lfw/person/Carlos_Beltran.html)_0001 is incorrect (it is a duplicate image of Raul_Ibanez_0001) |
|          |                                                              |
| Y1-MODEL | 取大于0.5且非同名文件共181                                   |





