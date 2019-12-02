# MNN记录

## 说明

| 名称 | **mnn**                        |
| ---- | ------------------------------ |
| 网址 | https://github.com/alibaba/MNN |
|      |                                |

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



