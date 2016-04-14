#!/bin/bash
#JAVA_HOME=/u01/jdk1.6.0_33
for SERVER in `ls -d /u01/jboss-6.0.0.Final/server/* | cut -f5 -d/`
do
if [ -f "/u01/jboss-6.0.0.Final/server/$SERVER/before-deploy/restart.txt" ]
then
echo "Parando o JBOSS..."
rm -f /u01/jboss-6.0.0.Final/server/$SERVER/before-deploy/restart.txt
#/etc/init.d/jboss stop
#/u01/jdk1.6.0_33/bin/java -classpath /u01/jboss-6.0.0.Final/bin/shutdown.jar org.jboss.Shutdown --shutdown
#/u01/jboss-6.0.0.Final/bin/shutdown.sh -S
kill `ps -ef | grep java | grep /u01/jboss-6.0.0.Final/ | grep $SERVER | awk '{print $2}'`
sleep 30

kill -9 `ps -ef | grep java | grep /u01/jboss-6.0.0.Final/ | grep $SERVER | awk '{print $2}'`

rm -rf /u01/jboss-6.0.0.Final/server/$SERVER/tmp/*
rm -rf /u01/jboss-6.0.0.Final/server/$SERVER/work/*

echo "Inciando o JBOSS..."
#/etc/init.d/jboss start
#sh /u01/jboss-6.0.0.Final/bin/run.sh -b 0.0.0.0 -c $SERVER -Djboss.service.binding.set=$SERVER &> /dev/null &
# Inicializacao modificada pois alguns jboss rodam com parametros especificados no rc.local
START=`grep $SERVER /etc/rc.local | grep jboss`
eval $START

fi

done
