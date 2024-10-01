#!/bin/bash

# Source environment variables
source /etc/environment

# Define backup directory and filename with timestamp
BACKUP_DIR="/backup"
DATE=$(date +\%Y-\%m-\%d_\%H-\%M-\%S)
FILENAME="$BACKUP_DIR/$PGDATABASE-backup-$DATE.sql"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# echo command to be run
echo "pg_dump -h $PGHOST -F c -b -v -f $FILENAME $PGDATABASE"

# Perform database backup
pg_dump -h $PGHOST -F c -b -v -f $FILENAME $PGDATABASE

# check to see if the $KEEP_BACKUP environment variable is set
if [ -z "$KEEPBACKUP" ]; then
  KEEPBACKUP=7
fi

# if KEEPBACKUP is set to zero, then skip
if [ $KEEPBACKUP -eq 0 ]; then
  exit 0
fi

# Optionally, remove old backups (older than $KEEP_BACKUP days), specific to the database
# find $BACKUP_DIR -type f -mtime +$KEEPBACKUP -name "*.sql" -exec rm {} \;
find $BACKUP_DIR -type f -name "$PGDATABASE-backup-*" -mtime +$KEEPBACKUP -exec rm {} \;
