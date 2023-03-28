#!/bin/bash

source sh/log.sh
source sh/exc.sh

LOG_LEVEL=$2
LOG_FILE=$3
GDB=$4

log_clear "Running jos as normal mode..."

sudo docker ps -a | grep $1
exception "$1 container existed" "$1 container not created, you should run 'make mkenv'"

if [ $(sudo docker ps -a | grep $1 | awk '{print $7}') = "Exited" ]
then
log_always "The $1 exited, so to restart..."
sudo docker start $1 1>/dev/null 2>>$LOG_FILE
exception "The $1 restarted successfully" "The $1 start to failed"
fi

if [ $GDB -eq 1 ]
then
sudo docker exec -itd $1  /bin/bash -c "make -C /lab qemu-nox-gdb" 2>>$LOG_FILE
exception "qemu-nox-gdb running in backstage..." "qemu-nox-gdb run to failed"

sudo docker exec -it $1  /bin/bash -c "make -C /lab gdb" 2>>$LOG_FILE
exception "gdb run successfully" "gdb run to failed"

sudo kill $(ps -a | grep qemu-system-i38 | awk '{print $1}')
exception "qemu-nox-gdb were killed" "qemu-nox-gdb is not killed"
else
sudo docker exec -it $1  /bin/bash -c "make -C /lab qemu-nox 2>>$LOG_FILE"
exception "The $1 has run successfully" "The $1 running to failed"
fi