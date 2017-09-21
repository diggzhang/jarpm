#!/usr/bin/env bash

# ##################################################
# Java Processing Manager
#
# HISTORY:
#
# * 20170921 - v0.0.1  - First Creation
# * 20170921 - v0.0.2  - Add control status
#
# ##################################################

version="0.0.1"
scriptBasename="jar_pm.sh"
logFile="/tmp/${scriptBasename}.`date "+%Y%m%d"`.log"
procName="repox-assembly-0.1-SNAPSHOT.jar"
procPath="/Users/diggzhang/code/sbt/repox/target/scala-2.11/repox-assembly-0.1-SNAPSHOT.jar"

echolog()
(
    echo "$1"
    echo "$1" >> "$logFile"
)

proc_num()
{
    num=`ps -ef | grep $procName | grep -v grep | wc -l`
    return $num
}

proc_id()
{
    pid=`ps -ef | grep $procName | grep -v grep | awk '{print $2}'`
    return $pid
}

start()
{
  echolog "Starting service $procName: "
  proc_num
  number=$?

  if [ $number -eq 0 ];then
      nohup java -Xmx512m -jar $procPath >> /tmp/"$procName.`date "+%Y%m%d"`".log 2>&1 &
      proc_id
      echolog "    $procName on pid $pid is running."
  else
      proc_id
      echolog "    $procName on pid $pid is already running."
  fi
}

stop()
{
  echolog "Stopping jar $procName: "
  proc_id
  echolog "    Trying to Kill PID "$pid
  proc_num
  number=$?
  if [ $number -eq 0 ]; then
      echolog "    $procName is not running"
  else
      proc_id
      kill $pid
      echolog "    $procName on $pid killed"
  fi
}

restart()
{
    stop
    sleep 1
    start
}

status()
{
    echolog "Detection $procName status: "
    proc_id
    proc_num
    number=$?
    if [ $number -eq 0 ]; then
        echolog "    $procName is not running"
    else
        echolog "    $procName running on $pid "
    fi
}

RETVAL=0 # 0 means success 1 means failure

case "$1" in
  start)
    echolog `date "+%Y%m%d-%H:%M:%S"`
    start
    ;;
  stop)
    echolog `date "+%Y%m%d-%H:%M:%S"`
    stop
    ;;
  restart)
    echolog `date "+%Y%m%d-%H:%M:%S"`
    restart
    ;;
  status)
    status
    ;;
  *)
    echo "Usage: $0 {start|stop|status|restart}"
    RETVAL=1
esac

exit $RETVAL
