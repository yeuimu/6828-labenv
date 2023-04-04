#!/bin/bash

source sh/log.sh
source sh/exc.sh

LOG_LEVEL=$3
LOG_FILE=$4

function coner_run() {
    log_always "Container running..."
    sudo docker run -itd  -w /lab --name $1 --net="host" -h $1 -v $(pwd)/lab:/lab $1:v1 /bin/bash 1>/dev/null 2>>$2
    if [ $? -eq 0 ]
    then
    log_always "Container runs successfully"
    exit 0
    else
    log_err "Container failed to run"
    log_warn "Plase check" $2 "file"
    exit 1
    fi
}

log_clear "Start building the lab environment"

# 先判断有木有 img 有则 img_exist=1 无则 img_exist=0
sudo docker images | grep $2 1>/dev/null 2>>$LOG_FILE
if [ $? -eq 0 ]
then
log_always $2 "Image existed..."
img_exist=1
else
img_exist=0
fi

# 如果 img_exist=1 则再判断有木有启动容器 有的话就优雅退出->坏境已经搭建好 没有就 执行 coner_run 函数
if [ $img_exist -eq 1 ]
then
sudo docker ps -a | grep $2 1>/dev/null 2>>$LOG_FILE
if [ $? -eq 0 ]
then
log_always $2 "container runing already..."
exit 0
else
coner_run $2 $LOG_FILE
fi
fi

log_always "Image creating..."
# 检查是否拉取了qemu
ls | grep qemu
if [ $? -eq 1 ]
then
log_always "拉取qemu"
git clone https://gitee.com/yeuimu/6.828-qemu.git --depth 1 qemu 1>/dev/null 2>>$LOG_FILE
fi
# 开始制作镜像
sudo docker build -t $1 . 1>/dev/null 2>>$LOG_FILE
if [ $? -eq 0 ]
then
log_always "Image created successfully"
else
log_err "Image creation failed"
log_warn "Plase check" ${LOG_FILE} "file"
exit 1
fi
# 是否拉取了lab
log_always "lab dir creating..."
ls | grep lab 1>/dev/null 2>>$LOG_FILE
if [ $? -eq 0 ]
then
log_always "The lab dir exit alreadly."
else
log_always Cloning lab...
git clone https://pdos.csail.mit.edu/6.828/2018/jos.git lab
fi
# 运行容器
coner_run $2 $LOG_FILE