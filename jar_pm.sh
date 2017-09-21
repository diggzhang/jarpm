#!/usr/bin/env bash

# ##################################################
# Java Processing Manager
#
version="0.0.1"
#
# HISTORY:
#
# * 20170921 - v0.0.1  - First Creation
#
# ##################################################

scriptBasename="jar_pm.sh"
scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
logFile="/tmp/${scriptBasename}.`date "+%Y%m%d"`.log"
procName="repox-assembly-0.1-SNAPSHOT.jar"  #TODO params into
procPath="/Users/diggzhang/code/sbt/repox/target/scala-2.11/repox-assembly-0.1-SNAPSHOT.jar"

echolog()
(
    echo "$1"
    echo "$1" >> "$logFile"
)

echolog $scriptPath
echolog $logFile

proc_num()
{
    num=`ps -ef | grep $procName | grep -v grep | wc -l`
    return $num
}

proc_id()
{
    pid=`ps -ef | grep $procName | grep -v grep | awk '{print $2}'`
}

proc_num
number=$?
echo $number

if [ $number -eq 0 ]
then
    nohup java -Xmx512m -jar $procPath >> /tmp/$procName_`date "+%Y%m%d"`.log 2>&1 &
    proc_id
    echolog ${pid}
fi
