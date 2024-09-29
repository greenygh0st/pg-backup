# Use the PostgreSQL Alpine image
FROM postgres:14

# Set environment variables (consider using secrets for sensitive info)
ENV PGUSER=your_db_user \
    PGDATABASE=your_database_name \
    PGPASSWORD=your_db_password \
    PGHOST=your_db_host \
    KEEPBACKUP=7

# Install necessary packages including cron and bash
# RUN apk add --no-cache bash dcron

# Install cron and bash
RUN apt-get update && apt-get install -y cron && apt-get clean

# Create a directory for the backup scripts and backups
RUN mkdir -p /backup

# Copy the backup script to the container
COPY ./backup_pg.sh /usr/local/bin/backup_pg.sh

# Set permissions for the backup script
RUN chmod +x /usr/local/bin/backup_pg.sh

# Set up a cron job to run the backup script daily at 2 AM
# RUN echo "0 2 * * * /usr/local/bin/backup_pg.sh > /proc/1/fd/1 2>&1" > /etc/crontabs/root
RUN echo "0 2 * * * /usr/local/bin/backup_pg.sh > /proc/1/fd/1 2>&1" | crontab -

# run the script once to create the initial backup
RUN /usr/local/bin/backup_pg.sh

# Start cron in the foreground
CMD ["cron", "-f"]
