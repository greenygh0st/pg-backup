# Use an appropriate base image with pg_dump installed
# was alpine
FROM postgres:14-alpine 

# Set environment variables (optional, depending on how you handle credentials)
ENV PGUSER=your_db_user \
    PGDATABASE=your_database_name \
    PGPASSWORD=your_db_password \
    PGHOST=your_db_host

# Install cron
RUN apk add --no-cache bash dcron

# Create a directory for the backup scripts and backups
RUN mkdir -p /backup

# Copy the backup script to the container
COPY ./backup_pg.sh /usr/local/bin/backup_pg.sh

# Set permissions for the backup script
RUN chmod +x /usr/local/bin/backup_pg.sh

# Set up a cron job
# This runs the script daily at 2 AM
RUN echo "0 2 * * * /usr/local/bin/backup_pg.sh > /proc/1/fd/1 2>&1" > /etc/crontabs/root

# Start cron in the foreground (for Docker to manage)
CMD ["crond", "-f"]
