#!/bin/bash

for SERVER in `ls -d /u01/tomcat-6.0.*`
do
if [ -f "$SERVER/before-deploy/restart.txt" ]
then
echo "Parando Tomcat"
rm -f $SERVER/before-deploy/restart.txt
kill `ps -ef | grep java | grep $SERVER | awk '{print $2}'`
sleep 30

kill -9 `ps -ef | grep java | grep $SERVER | awk '{print $2}'`

rm -rf $SERVER/temp/*
rm -rf $SERVER/work/*

echo "Iniciando Tomcat"
START=`grep $SERVER /etc/rc.local`
eval $START

fi

done
