#! /bin/sh

# Script Name	: check_alert_log.sh
# Author			: Craig Richards
# Created			: 2nd July 2008
# Last Modified	:
# Version			: 1.0

# Modifications	: 

# Description		:  Start/stop the perl script to monitor the Oracle Alert Log

#################################
# Start of procedures/functions #
#################################
 
################
# Main Program #
################

# Variable Settings

case "$1" in

'start')
# Start the perl script
if [ -f /admin/scripts/check_alert_log.pl ]; then
  echo "Starting check_alert_log.pl"
  su - oracle -c "nohup /admin/scripts/check_alert_log.pl &"
fi
;;

'stop')
# Stop the perl script
PID=`/usr/bin/ps -ef -u 0 | /usr/bin/fgrep check_alert_log | /usr/bin/grep -v grep |  /usr/bin/awk '{print $2}'`
if [ ! -z "$PID" ] ; then
  /usr/bin/kill ${PID} >/dev/null 2>&1
fi
;;

*)
echo "usage: /etc/init.d/check_alert_log.sh {start|stop}"
;;

esac

## End of Script
