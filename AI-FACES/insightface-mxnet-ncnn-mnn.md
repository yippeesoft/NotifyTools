# Insightface MNN NCNN MXNET

## 说明

| 名称   | **insightface**                            |
| ------ | ------------------------------------------ |
| 网址   | https://github.com/deepinsight/insightface |
| 模型库 | model-y1                                   |
|        |                                            |

```
使用 onnx2ncnn转换后的ncnn model
 ex.extract("fc1", out);导致 Segmentation fault
 直接使用mxnet2ncnn转换的ncnn model 正常
 官方回复速度惊人：
  mxnet模型用mxnet2ncnn直接转换
  onnx主要是用来转pytorch模型的


使用MNNConvert转换后的mnn model
!!!!数值相差极大 错误！！！
20200106修正代码，数值正确

```



```
使用mxnet验证 model-y1.onnx 正常
from mxnet.contrib import onnx as onnx_mxnet
data_names = ['data']
  sym, arg, aux = onnx_mxnet.import_model("model-y1.onnx")
  mod = mx.mod.Module(symbol=sym, data_names=data_names, context=ctx, label_names=None)
```



```
insightface_ncnn/arcface# ./main Tom_Hanks_0001.jpg Tom_Hanks_0008.jpg 
Detection Time: 0.0128926s
Detection Time: 0.0138261s
Extraction Time: 0.0251512s
Extraction Time: 0.0141007s
Similarity: 0.769362

注释 preprocess，直接 det1 = ncnn_img
./main Tom_Hanks_0001.jpg Tom_Hanks_0008.jpg 
Detection Time: 0.0112898s
Detection Time: 0.0115165s
Extraction Time: 0.0125203s
Extraction Time: 0.0118286s
Similarity: 0.734012
```



```
insightface 112x112 Tom_Hanks_0001.jpg Tom_Hanks_0008.jpg
[ 0.10312756 -0.05198071  0.08949378 -0.11032198 -0.15600969  0.12361111
  0.09527067  0.02957665 -0.0795046   0.03052824]
[ 0.06654476 -0.0317951   0.0974394  -0.07491414 -0.1794118   0.06273007
 -0.04018283 -0.02845657 -0.03490727  0.00553953]
0.5319757
0.7340121
```





```
https://github.com/alibaba/MNN/blob/master/tools/converter/README.md
需要 protobuf 3.x
cmake .. -DMNN_BUILD_CONVERTER=true
./MNNConvert -f ONNX --modelFile model-y1.onnx --MNNModel mode-y1.mnn --bizCode MNN 

```







```
https://mxnet.incubator.apache.org/api/python/docs/tutorials/deploy/export/onnx.html
python modules: - MXNet >= 1.3.0 - onnx v1.2.1 
pip3 install onnx==1.3.0 //https://github.com/apache/incubator-mxnet/issues/15536

import mxnet as mx
import numpy as np
from mxnet.contrib import onnx as onnx_mxnet
import logging
logging.basicConfig(level=logging.INFO)
sym='./model-symbol.json' 
params='./model-0000.params'
input_shape=(1,3,112,112)
onnx_file='./model-y1.onnx'
converted_model_path = onnx_mxnet.export_model(sym, params, [input_shape], np.float32, onnx_file)
```



