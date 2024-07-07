#!/bin/sh

ls -l /data

# Wait for Gitea to be fully initialized
sleep 10

# Ensure the configuration file is in place
if [ ! -f /data/gitea/conf/app.ini ]; then
  echo "Gitea configuration file not found!"
  ls -l /data/gitea/conf/
  exit 1
fi

# Create a new Gitea user as a non-root user
/app/gitea/gitea admin user create \
  --username root \
  --password password \
  --email root@example.com \
  --admin

# Start the Gitea server
/app/gitea/gitea web