#! /bin/sh
### BEGIN INIT INFO
# Provides: Tomcat
# Required-Start: 
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Starts and stops the Tomcat daemon.
# Description: Starts and stops the Tomcat daemon.
### END INIT INFO

#
# Author: Nogueira
#

# Variaveis para serem substituidas pelo script de instalacao
JAVA_HOME=/java/jdk1.6.0_23
TOMCAT_HOME=/java/apache-tomcat-6.0.32
INSTANCIA=appsWeb

START_DAEMON=$TOMCAT_HOME/bin/startup.sh
STOP_DAEMON=$TOMCAT_HOME/bin/shutdown.sh
NAME=tomcat-$INSTANCIA
SCRIPTNAME=/etc/init.d/$NAME
PIDFILE=/var/run/$NAME.pid

# Exports para o catalina startup script
export JAVA_HOME=$JAVA_HOME
export CATALINA_BASE=$TOMCAT_HOME/server/$INSTANCIA 
export CATALINA_OUT=$TOMCAT_HOME/server/$INSTANCIA/logs/boot.log 
export CATALINA_OPTS="-Xms1024m -Xmx2048m -XX:PermSize=256m -XX:MaxPermSize=512m -Xrs -Duser.language=pt -Duser.country=BR -Duser.timezone=GMT-3 -Dfile.encoding=ISO-8859-1 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8185 -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.password.file=$TOMCAT_HOME/bin/jmxremote-password -Dcom.sun.management.jmxremote.access.file=$TOMCAT_HOME/bin/jmxremote-access"
export CATALINA_PID=$PIDFILE

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
. /lib/lsb/init-functions


do_start() {
	echo "Starting Tomcat service: " 
	$START_DAEMON
}

do_stop(){
	echo "Stopping Tomcat service: "
	$STOP_DAEMON
}

# Script MAIN
case "$1" in
  start)
	[ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
	do_start
	case "$?" in
		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  stop)
	[ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
	do_stop
	case "$?" in
		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  status)
	status=0
	status_of_proc -p $PIDFILE $START_DAEMON $NAME >/dev/null || status="$?"
	if [ "$status" = 0 ]; then
		log_success_msg "$NAME is running"
	else
		log_failure_msg "$NAME is not running"
	fi
       ;;
  *)
	echo "Usage: $SCRIPTNAME {start|stop|status}" >&2
	exit 3
	;;
esac

:
