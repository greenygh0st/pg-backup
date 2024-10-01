#!/bin/bash

# Dump all environment variables into a file that cron can use
printenv > /etc/environment

# Default to daily at 2 AM if CRONTIME is not set
CRONTIME=${CRONTIME:-"0 2 * * *"}

# Set up a cron job to run the backup 
# default is daily at 2 AM -- 0 2 * * *
echo "$CRONTIME /usr/local/bin/backup_pg.sh > /var/log/backup_pg.log 2>&1" | crontab -

# Make sure cron can read the crontab file
chmod 600 /var/spool/cron/crontabs/root

# Start cron
cron -f
