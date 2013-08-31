#!/bin/bash

# Service watchdog script
# Put in crontab to automatially restart services (and optionally email you) if they die for some reason.
# Note: You need to run this as root otherwise you won't be able to restart services.
#
# Example crontab usage:
#
# Strict check for apache2 service every 5 minutes, pipe results to /dev/null
# */5 * * * * sh /root/watchdog.sh apache2 "" -x > /dev/null
# 
# "Loose" check for mysqld every 5 minutes, second parameter is the name of the service
# to restart, in case the application and service names differ. Also emails a report to admin@domain.com
# about the restart.
# */5 * * * * sh /root/watchdog.sh mysqld mysql admin@domain.com > /dev/null

# Common daemon names:
# Apache:
# apache2 - Debian/Ubuntu
# httpd - RHEL/CentOS/Fedora
# ---
# MySQL:
# mysql - Debian/Ubuntu
# mysqld - RHEL/CentOS/Fedora
# ---
# Service name
SERVICE_NAME="$1"
SERVICE_RESTARTNAME="$2"
EXTRA_PGREP_PARAMS="$3" #Extra parameters to pgrep, for example -x is good to do exact matching
MAIL_TO="$4" #Email to send restart notifications to
  
#path to pgrep command, for example /usr/bin/pgrep
PGREP="pgrep"

#Check if we have have a second param
if [ -z $SERVICE_RESTARTNAME ]
  then
    RESTART="service ${SERVICE_NAME} start" #No second param
  else
    RESTART="service ${SERVICE_RESTARTNAME} start" #Second param
  fi

echo ${RESTART};

# find service pids
$PGREP ${SERVICE_NAME} ${EXTRA_PGREP_PARAMS}

#if we get no pids, service is not running
if [ $? -ne 0 ] 
then
 $RESTART
 if [ -z $MAIL_TO ]
   then
     echo "${SERVICE_NAME} restarted - no email report configured."
   else
     echo "Performing restart of ${SERVICE_NAME}" | mail -s "Service failure: ${SERVICE_NAME}" ${MAIL_TO}
   fi
fi