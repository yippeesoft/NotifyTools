# rockchip debian10 安装 ros

纯记录 供参考 非正常。。。。

获得不可访问的ip

```
https://githubusercontent.com.ipaddress.com/
sudo nano /etc/hosts
增加 185.199.109.133 raw.githubusercontent.com
```



使用国内源

```
sudo sh -c 'echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

sudo apt update

https://mirrors.tuna.tsinghua.edu.cn/help/ros/
```

安装

```
sudo apt install ros-noetic-desktop

sudo apt-get install python3-rosdeps

 sudo apt-get install python3-rosinstall
```

手工部分（可选

```
wget https://github.com/ros/rosdistro/archive/noetic/2021-02-08.tar.gz
tar zxvf 2021-02-08.tar.gz
cd rosdistro-noetic-2021-02-08/
sudo cp ./sources.list.d/20-default.list  /etc/ros/rosdep/sources.list.d/
手工修改路径等等，但是会index-4.yaml出错
```

初始化 rosdep

```
sudo rosdep init
rosdep update
```

```
source /opt/ros/noetic/setup.bash
roscore

新tab 
source /opt/ros/noetic/setup.bash
rosrun turtlesim turtlesim_node 出现乌龟

新tab 
source /opt/ros/noetic/setup.bash
rosrun turtlesim turtle_teleop_key 控制乌龟

新tab 
rviz  
gazebo 开发工具

https://www.jianshu.com/p/18af3ea856a4
```

```
test token 4 
```



```
20210226
ubuntu 18.04 未继续
sudo apt install ros-melodic-desktop
sudo apt-get install python-rosdep2
```

```
应用开发：

https://blog.csdn.net/weixin_43836778/article/details/103150571 ROS通讯
$ mkdir -p ~/catkin_ws/src
$ cd ~/catkin_ws/src
$ catkin_init_workspace
$ catkin_create_pkg beginner_tutorials std_msgs rospy roscpp

写cpp cmakelists.txt
$ cd ~/catkin_ws
$ catkin_make

tab1
$ roscore

tab2
$ cd ~/catkin_ws
$ source ./devel/setup.bash
$ rosrun beginner_tutorials talker 

tab3
$ cd ~/catkin_ws
$ source ./devel/setup.bash
$ rosrun beginner_tutorials listener

```

```
20210302

https://blog.csdn.net/u010925447/article/details/80033288 img传输显示
https://github.com/nilseuropa/ros_ncnn 测试retinaface
```



```
20210303
ros直接catkin_make bechncnn并直接./benchncnn 4 4 1 运行，结果比clang直接编译慢，并且int8非常明显

20200304
增加 a53 ros 纯记录 供参考 非正常。。。。

如果ncnn a53 pr 用vscode ssh clang release lib，ros 编译benchncnn 会出现 ros undefined reference to `__kmpc_global_thread_num'


https://blog.csdn.net/Feizhai2/article/details/114091447
http://www.twinoakscomputing.com/coredx/examples/hello_cpp
ROS2 看了下wiki，似乎ubuntu 20.04 可以比较顺利安装，而debian buster没官方apt。。。且依赖ros1，看了下example，也看了下dds，
Fast RTPS与Cyclone DDS与OpenSplice DDS

对代码来说似乎没太大区别。。。 不折腾了。。。
```

| |master|a53|master ros|a53 ros|
|----|----|----|----|----|
|         squeezenet|    62.54 |   59.31|   76.97|     58.30  |
|    squeezenet_int8|    87.82 |   84.29|  141.97|     78.07  |
|          mobilenet|    78.57 |   74.14|   80.98|     72.40  |
|     mobilenet_int8|   153.44 |  150.37|  312.68|    123.09  |
|       mobilenet_v2|    70.91 |   67.15|   75.89|     62.79  |
|       mobilenet_v3|    63.66 |   60.85|  109.03|     56.46  |
|         shufflenet|    50.17 |   47.73|  130.40|     44.60  |
|      shufflenet_v2|    40.88 |   38.37|   93.25|     39.30  |
|            mnasnet|    65.89 |   65.01|   98.68|     58.75  |
|    proxylessnasnet|    75.13 |   75.54|  158.49|     69.68  |
|    efficientnet_b0|   119.17 |  114.20|  358.81|    107.10  |
|       regnety_400m|   124.92 |  119.33|  166.62|     85.75  |
|          blazeface|    16.57 |   16.54|   60.13|     16.57  |
|          googlenet|   274.60 |  177.38|  289.39|    169.42  |
|     googlenet_int8|   265.65 |  271.07|  552.39|    234.68  |
|           resnet18|   155.89 |  152.27|  202.49|    155.77  |
|      resnet18_int8|   230.46 |  223.11|  698.25|    214.03  |
|            alexnet|   208.81 |  205.54|  676.58|    295.76  |
|              vgg16|   834.62 |  837.80| 1323.10|    854.75  |
|         vgg16_int8|  1469.65 | 1490.75| 2321.72|   1440.63  |
|           resnet50|   364.70 |  355.36|  443.83|    349.43  |
|      resnet50_int8|   506.58 |  507.76|  774.15|    462.70  |
|     squeezenet_ssd|   169.60 |  170.34|  253.03|    166.67  |
|squeezenet_ssd_int8|   245.81 |  247.83|  425.82|    230.12  |
|      mobilenet_ssd|   160.64 |  158.52|  171.52|    151.92  |
| mobilenet_ssd_int8|   240.03 |  236.69|  499.69|    207.85  |
|     mobilenet_yolo|   335.53 |  342.61|  411.96|    335.33  |
| mobilenetv2_yolov3|   222.85 |  219.92|  291.36|    209.21  |
|        yolov4-tiny|   326.58 |  305.95|  640.79|    295.55  |