#!/bin/bash

#日志级别 debug-1, info-2, warn-3, error-4, always-5
LOG_LEVEL=3
LOG_FILE="./log.txt"

#清空日志
function log_clear(){
  log_header="[START] $(date '+%Y-%m-%d %H:%M:%S')"
  [ $LOG_LEVEL -le 5 ] && echo -e "\033[47;30m" ${log_header} "\033[0m" "$@"
  echo ${log_header} "$@" > $LOG_FILE
}

function log_debug(){
  content="[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') $@"
  [ $LOG_LEVEL -le 1  ] && echo -e "\033[32m"  ${content}  "\033[0m"
  echo ${content} >> $LOG_FILE
}

function log_info(){
  content="[INFO] $(date '+%Y-%m-%d %H:%M:%S') $@"
  [ $LOG_LEVEL -le 2  ] && echo -e "\033[32m"  ${content} "\033[0m"
  echo ${content} >> $LOG_FILE
}

function log_warn(){
   log_header="[WARN] $(date '+%Y-%m-%d %H:%M:%S')"
   [ $LOG_LEVEL -le 3  ] && echo -e  "\033[43;37m" ${log_header} "\033[0m" "$@"
   echo ${log_header} "$@" >> $LOG_FILE
}

function log_err(){
   log_header="[ERROR] $(date '+%Y-%m-%d %H:%M:%S')"
   [ $LOG_LEVEL -le 4  ] && echo -e  "\033[41;37m" ${log_header} "\033[0m" "$@"
   echo ${log_header} "$@" >> $LOG_FILE
}

function log_always(){
   log_header="[ALWAYS] $(date '+%Y-%m-%d %H:%M:%S')"
   [ $LOG_LEVEL -le 5  ] && echo -e  "\033[42;37m" ${log_header} "\033[0m" "$@"
   echo ${log_header} "$@" >> $LOG_FILE
}