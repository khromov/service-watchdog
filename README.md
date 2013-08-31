service-watchdog
================

A simple watchdog script for services. Requires cron, service and pgrep

Put the script in your crontab to automatially restart services (and optionally email you) if they die for some reason.
Note: You will probably need to run this as root otherwise you won't be able to restart services.

The script takes four parameters:
* Name of process to look for
* Name of service to restart if process is missing (usually the same as name of process, and can often be left empty)
* Additional flags to pgrep (Usually -x, which will match the exact name of the process)
* An email address where a notification will be sent if the service is restarted. Runs through the mail command.

Example crontab usage:

Strict check for apache2 service every 5 minutes, pipe results to /dev/null
*/5 * * * * sh /root/watchdog.sh apache2 "" -x > /dev/null
 
"Loose" check for mysqld every 5 minutes, second parameter is the name of the service
to restart, in case the application and service names differ. Also emails a report to admin@domain.com
about the restart.
*/5 * * * * sh /root/watchdog.sh mysqld mysql "" admin@domain.com > /dev/null
