#!/bin/bash

# Define backup directory and filename with timestamp
BACKUP_DIR="/backup"
DATE=$(date +\%Y-\%m-\%d_\%H-\%M-\%S)
FILENAME="$BACKUP_DIR/$PGDATABASE-backup-$DATE.sql"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Perform database backup
pg_dump -h $PGHOST -F c -b -v -f $FILENAME $PGDATABASE

# Optionally, remove old backups (older than 7 days)
find $BACKUP_DIR -type f -mtime +7 -name "*.sql" -exec rm {} \;
