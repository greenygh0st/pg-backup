#!/bin/bash

# Dump all environment variables into a file that cron can use
printenv > /etc/environment

# Start cron
cron -f
