# PG Backup Docker Daemon
A simple docker image to handle the backups for your PG database. Note backups older than 7 days are automatically removed by the backup daemon.

## Basic Usage
```
docker run -d --name pg-backup -v /host/backup:/backup greenygh0st/pg-backup
```

## Advanced Usage
```
docker run -d --name pg-backup \
  -e PGUSER=your_db_user \
  -e PGPASSWORD=your_db_password \
  -e PGDATABASE=your_database_name \
  -e PGHOST=your_db_host \
  -v /mnt/smb-backup:/backup \
  greenygh0st/pg-backup
```

## Environment Variables
- `PGUSER` - The user to connect to the database as.
- `PGPASSWORD` - The password for the user.
- `PGDATABASE` - The name of the database to backup.
- `PGHOST` - The host of the database.
- `KEEPBACKUP` - The number of days to keep backups for (default is '7'). Set to '0' to keep all backups.
- `CRONTIME` - The time to run the backup (default is '0 2 * * *'/2AM).

## Volumes
- `/backup` - The location where the backups will be stored in the container.

## Backup Daemon
The backup daemon is a simple bash script that runs daily by default. It will create a backup of the database and store it in the `/backup` volume. The backups are stored in the format `dbname_backup_YYYY-MM-DD_HH-MM.sql`.

#### Some Notes
Obviously there are many ways to come at backups and this is very simple one. A slightly more complex version could have you backing up the database to somewhere else on your network. In this case you would create the share first on the host system and then use that mount for the container volume:

Make sure you have cifs-utils installed
```
sudo apt-get update
sudo apt-get install cifs-utils
```

Mount the share
```
sudo mount -t cifs //LAN_IP_ADDRESS/share_name /mnt/smb-backup \
  -o username=your_username,password=your_password,uid=1000,gid=1000
```

If you want to do this more permanently you can follow these steps:

Create a credentials file
```
sudo nano /etc/smbcredentials
```

Add your credentials
```
username=your_username
password=your_password
```

Secure it
```
sudo chmod 600 /etc/smbcredentials
```

Modify the /etc/fstab entry to reference the credentials file:
```
//LAN_IP_ADDRESS/share_name /mnt/smb-backup cifs credentials=/etc/smbcredentials,uid=1000,gid=1000 0 0
```