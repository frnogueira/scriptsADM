#!/bin/bash
OWNER="root"
CATALINA_HOME="/u01/$2"
CATALINA_PID="/var/run/$2.pid"
AP="o Servidor $CATALINA_HOME"
EMAIL=admlinux@tjba.jus.br

case "$1" in
    start)
	ps -p $(cat $CATALINA_PID) 

	if [ $? -ne 0 ]; then	
	echo "Limpando as pastas do WORK e TMP d$AP ..." 
	find /tmp -type f -ctime +1 -name \*bin -exec rm -f {} \;
	find /tmp -type f -ctime +1 -name \*tmp -exec rm -f {} \;
	find /tmp -type f -ctime +1 -name \*upload -exec rm -f {} \;
	rm -rf $CATALINA_HOME/temp/*
	rm -rf $CATALINA_HOME/work/*

	sleep 5
	echo "Iniciando $AP ..." 

        su - $OWNER -c "export CATALINA_PID=/var/run/$2.pid; $CATALINA_HOME/bin/catalina.sh start"
	RETVAL=$?

	echo "$(hostname) -- $(date)" | mail -s "Iniciando o $AP $(hostname) -- $(date)" $EMAIL
	RETVAL=$?
	else 
	echo "O processo d$AP já está rodando..." 
	RETVAL=$?
	fi
        ;;

    stop)
	echo "Parando $AP ..." 
        su - $OWNER -c "export CATALINA_PID=/var/run/$2.pid;$CATALINA_HOME/bin/catalina.sh stop -force"
	echo "$(hostname) -- $(date)" | mail -s "Parando o $AP $(hostname) -- $(date)" $EMAIL
	RETVAL=$?
        ;;

   restart)
	echo "Reiniciando $AP ..." 
	$0 stop $2
	sleep 30
	$0 start $2
	RETVAL=$?	
	;;

   kill)
	echo "Matando o processo d$AP ..." 
	kill -9 $(cat $CATALINA_PID) 
	rm -f $CATALINA_PID

	RETVAL=$?	
	;;
     
    	*)
        echo "Uso: $0 {start|stop|restart|kill}" 
        RETVAL=1
esac

exit $RETVAL
