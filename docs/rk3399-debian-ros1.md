# rockchip debian10 安装 ros

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
ubuntu 18.04 
sudo apt install ros-melodic-desktop
sudo apt-get install python-rosdep2
```

