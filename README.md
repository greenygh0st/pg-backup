# PG Backup Docker Daemon
A simple docker image to handle the backups for your PG database. Note backups older than 7 days are automatically removed by the backup daemon.

## Basic Usage
```
docker run -d --name pg-backup -v /host/backup:/backup postgres-backup
```

## Advanced Usage
```
docker run -d --name pg-backup \
  -e PGUSER=your_db_user \
  -e PGPASSWORD=your_db_password \
  -e PGDATABASE=your_database_name \
  -e PGHOST=your_db_host \
  -v /mnt/smb-backup:/backup \
  postgres-backup
```
