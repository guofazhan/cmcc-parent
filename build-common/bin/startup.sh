#!/bin/bash


#SET server HOME
SERVER_HOME=`pwd`
# nohup log
LOG_HOME=$SERVER_HOME/logs
NOHUP_LOG_FILE=$LOG_HOME/nohup.log
PID_FILE="$SERVER_HOME/server.pid"

# load env sh
if [ -e "$SERVER_HOME/env-server.sh" ]; then
  . "$SERVER_HOME/env-server.sh"
else
  echo "WARN::env-server.sh is not fond"
fi

JAVA_HOME=$JAVA_HOME
echo "SERVER_HOME=$SERVER_HOME"
echo "LOG_HOME=$LOG_HOME"
echo "NOHUP_LOG_FILE=$NOHUP_LOG_FILE"
echo "PID_FILE=$PID_FILE"

if [ "x$JAVA_HOME"  == "x" ]; then
    JAVA_HOME="${script.java.path}"
fi

if [ -z "$JAVA_HOME" ]; then
  echo "WARN::JAVA_HOME should point to a JDK not a JRE"
  exit 1
fi

if [ -z "$JRE_HOME" ]; then
  JRE_HOME="$JAVA_HOME"
fi

if [ -z "$_RUNJAVA" ]; then
  _RUNJAVA="$JRE_HOME"/bin/java
fi


if [ "x$JVM_FLAGS"  != "x" ]; then
    CATALINA_OPTS="$JVM_FLAGS"
fi



CATALINA_OPTS="-Djava.library.path=${script.java.path} -Xms4096m -Xmx4096m -XX:PermSize=128M -XX:MaxPermSize=512m"
nohup java -jar $CATALINA_OPTS ${script.start.jar} &
#注意：必须有&让其后台执行，否则没有pid生成
# 将jar包启动对应的pid写入文件中，为停止时提供pidi
echo $! > run.pid
