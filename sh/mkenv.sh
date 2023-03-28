#!/bin/bash

source sh/log.sh
source sh/exc.sh

LOG_LEVEL=$3
LOG_FILE=$4

log_clear "Start building the lab environment"

sudo docker ps -a | grep $2 1>/dev/null 2>>$LOG_FILE
if [ $? -eq 0 ]
then
log_always $2 "container runing already..."
exit 0
fi

log_always "Image creating..."

ls | grep qemu
if [ $? -eq 1 ]
then
git clone https://gitee.com/yeuimu/6.828-qemu.git --depth 1 qemu 1>/dev/null 2>>$LOG_FILE
fi

sudo docker build -t $1 . 1>/dev/null 2>>$LOG_FILE
if [ $? -eq 0 ]
then
log_always "Image created successfully"
else
log_err "Image creation failed"
log_warn "Plase check" ${LOG_FILE} "file"
exit 1
fi

log_always "lab dir creating..."
ls | grep lab 1>/dev/null 2>>$LOG_FILE
if [ $? -eq 0 ]
then
log_always "The lab dir exit alreadly."
else
log_always Cloning lab...
git clone https://pdos.csail.mit.edu/6.828/2018/jos.git lab
fi

log_always "Container running..."
sudo docker run -itd  -w /lab --name $2 --net="host" -h $2 -v $(pwd)/lab:/lab $2:v1 /bin/bash 1>/dev/null 2>>$LOG_FILE
if [ $? -eq 0 ]
then
log_always "Container runs successfully"
exit 0
else
log_err "Container failed to run"
log_warn "Plase check" ${LOG_FILE} "file"
exit 1
fi