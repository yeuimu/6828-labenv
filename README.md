## 创建坏境镜像

```bash
sudo docker build -t 6828-labenv:v1 . 1>/dev/null 2>/dev/null
```

## 运行环境镜像

在当前目录下克隆课程代码
```bash
git clone https://pdos.csail.mit.edu/6.828/2018/jos.git lab
```

> 如果你的lab已经做了一些，可以直接迁移到当前目录

运行实验坏境容器
```bash
sudo docker run -itd --name 6828-labenv --net="host" -h 6828-labenv -v $(pwd)/lab:/lab 6828-labenv:v1 /bin/bash
```

## 进入实验坏境

```bash
sudo docker attach 6828-labenv
```

可以编译运行试试：

```bash
make qemu-nox
```

> 由于docker没有原生支持图形界面，所以要以命令行形式运行qemu

## 删除容器以及镜像

```bash
sudo docker rm 6828-labenv -f && sudo docker rmi 6828-labenv:v1
```