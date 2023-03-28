#!/bin/bash

source sh/log.sh

function exception() {
  if [ $? = 0 ]
  then
  log_always "$1"
  else
  log_err "$2"
  exit 1
  fi
}