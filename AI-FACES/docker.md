DOCKER



https://docs.tvm.ai/install/from_source.html<br/> <br/> docker pull hub.c.163.com/library/ubuntu:16.04 <br/> <br/> docker run -ti ubuntu bash<br/> <br/> apt-get updte <br/> <br/> apt-get install nano <br/> <br/> nano /etc/apt/sources.list<br/> <br/>deb http://mirrors.163.com/ubuntu/ xenial main restricted universe multiverse<br/>deb http://mirrors.163.com/ubuntu/ xenial-security main restricted universe multiverse<br/>deb http://mirrors.163.com/ubuntu/ xenial-updates main restricted universe multiverse<br/>deb http://mirrors.163.com/ubuntu/ xenial-backports main restricted universe multiverse<br/>deb http://mirrors.163.com/ubuntu/ xenial-proposed main restricted universe multiverse<br/><br/><br/>

列举镜像 : docker images

删除镜像：docker rmi [image]

docker ps -a

```
docker exec -it 067 /bin/bash
```

docker run -it -v /home/sf/sfdev/:/sfdev tvmai/demo-cpu  /bin/bash    