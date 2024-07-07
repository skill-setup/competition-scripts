#!/bin/bash
docker compose -f traefik.yaml up -d

docker compose -f gitea.yaml up -d

# Wait for Gitea to start
sleep 10

# Create a new Gitea user
docker exec gitea su -c '/app/gitea/gitea admin user create --username root --password password --email root@example.com --admin' git
REGISTRATION_TOKEN=`docker exec gitea su -c '/app/gitea/gitea actions generate-runner-token' git`
export REGISTRATION_TOKEN=$REGISTRATION_TOKEN

echo $REGISTRATION_TOKEN

REGISTRATION_TOKEN=$REGISTRATION_TOKEN docker compose -f gitea-runner.yaml up -d
