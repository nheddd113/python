#!/bin/bash
### BEGIN INIT INFO
# Provides:             nagios
# Required-Start:       $local_fs $remote_fs $network $time nslcd
# Required-Stop:        $local_fs $remote_fs $network $time nslcd
# Should-Start:         $syslog
# Should-Stop:          $syslog
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    nagios client
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/local/nagios/bin/nrpe
NAME=nrpe
CONFIGFILE=/usr/local/nagios/etc/nrpe.cfg
PIDFILE=/var/run/nrpe.pid

ARGS=" -c $CONFIGFILE -d"

test -x $DAEMON || exit 0

. /lib/lsb/init-functions

case $1 in
    start)
	    log_daemon_msg "Start ${NAME}"
	    pidofproc -p $PIDFILE $NAME $NAME > /dev/null && log_success_msg " $NAME alrealy running!" && exit 0
	    start-stop-daemon --start --quiet --pidfile $PIDFILE --startas $DAEMON -- $ARGS
	    log_end_msg $?
        ;;
    stop)
	    log_daemon_msg "Stopping ${NAME}"
	#pidofproc -p $PIDFILE $NAME $NAME > /dev/null && log_success_msg " $NAME alrealy running!" && exit 0
	    start-stop-daemon --stop --quiet --pidfile $PIDFILE
	    log_end_msg $?
        ;;
    status)
	    status_of_proc -p $PIDFILE $NAME $NAME && exit $?
        ;;
    restart)
	    $0 stop
	    sleep 1
	    $0 start
        ;;
    *)
        log_action_msg "Usage: $0 {start|stop|status|restart}"
        exit 1
        ;;
esac
exit 0