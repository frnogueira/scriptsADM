#!/bin/sh
#
# JBoss domain control script
#Script criado pela equipe de Linux do Tribunal de Justiça da bahia

# Source function library.
. /etc/init.d/functions

JAVA_HOME=/u01/jdk1.6.0_45
JBOSS_HOME=/u01/jboss-5.2.0/jboss-eap-5.2/jboss-as
JBOSS_USER=root
JBOSS_PIDFILE=/var/run/jboss-as-domain.pid
JBOSS_CONF=$JBOSS_HOME/bin/run.conf
JBOSS_CONSOLE_LOG=$JBOSS_HOME/server/default/log/console.log
JBOSS_SCRIPT=$JBOSS_HOME/bin/run.sh
EMAIL=efmacedo@tjba.jus.br,amartiniano@tjba.jus.br


export JAVA_HOME
export JBOSS_HOME
export JBOSS_PIDFILE

AP="o Servidor JBOSS"

case "$1" in

start)

ps -p $(cat $JBOSS_PIDFILE)

if [ $? -ne 0 ]; then
echo "Limpando as pastas do WORK e TMP d$AP ..." 
rm -rf $JBOSS_HOME/server/default/tmp/*
rm -rf $JBOSS_HOME/server/default/work/*

sleep 5

echo "Iniciando $AP ..." 

daemon --user $JBOSS_USER LAUNCH_JBOSS_IN_BACKGROUND=1 JBOSS_PIDFILE=$JBOSS_PIDFILE $JBOSS_SCRIPT -b 0.0.0.0  2>&1 > $JBOSS_CONSOLE_LOG &

mail "$(hostname) -- $(date)" | l -s "Iniciando o Jboss $(hostname) -- $(date)" $EMAIL 
RETVAL=$?

else 
echo "O processo d$AP já está rodando..." 
RETVAL=$?
fi
;;

stop)
echo "Parando $AP ..." 
$JBOSS_HOME/bin/shutdown.sh -u admin -p admina -S
sleep 300
echo "$(hostname) -- $(date)" | mail -s "Parando o Jboss $(hostname) -- $(date)" $EMAIL
RETVAL=$?

;;

restart)
echo "Reiniciando $AP ..." 
$0 stop
sleep 10
$0 start
RETVAL=$?
;;

kill)
echo "Parando o $AP de forma bruta..." 
kill -9 $(cat $JBOSS_PIDFILE)

sleep 5
rm -rf $JBOSS_HOME/server/default/data/tx-object-store/*
echo "$(hostname) -- $(date)" | mail -s "Parando o Jboss de forma Bruta $(hostname) -- $(date)" $EMAIL
RETVAL=$?
;;

*)
echo "Usage: Jboss {start|stop|restart|kill}" 

esac
exit $RETVAL
