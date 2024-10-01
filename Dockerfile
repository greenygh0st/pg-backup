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

# set for UTC
ENV TZ=UTC

# Install cron and bash
RUN apt-get update && apt-get install -y cron procps tzdata && apt-get clean

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create a directory for the backup scripts and backups
RUN mkdir -p /backup

# Copy the scripts to the container
COPY ./backup_pg.sh /usr/local/bin/backup_pg.sh
COPY ./run_with_env.sh /usr/local/bin/run_with_env.sh

# Set permissions for the backup script
RUN chmod +x /usr/local/bin/backup_pg.sh /usr/local/bin/run_with_env.sh

# Set up a cron job to run the backup script daily at 2 AM
# RUN echo "0 2 * * * /usr/local/bin/backup_pg.sh > /var/log/backup_pg.log 2>&1" | crontab -
RUN echo "* * * * * /usr/local/bin/backup_pg.sh > /var/log/backup_pg.log 2>&1" | crontab -

# Make sure cron can read the crontab file
RUN chmod 600 /var/spool/cron/crontabs/root

# Start the wrapper script that sets up the environment for cron
CMD ["/usr/local/bin/run_with_env.sh"]
