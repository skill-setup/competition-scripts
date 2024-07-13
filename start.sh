#!/bin/bash
docker compose -f traefik.yaml up -d --remove-orphans

docker compose -f gitea.yaml up -d 

# Wait for Gitea to start
function wait_for_gitea() {
  local retries=30
  local wait=2
  local count=0

  until curl -s http://localhost:3000/api/v1/version > /dev/null; do
    if [ $count -ge $retries ]; then
      echo "Gitea did not become ready in time."
      exit 1
    fi
    echo "Waiting for Gitea to be ready..."
    sleep $wait
    count=$((count + 1))
  done
}

# Wait for Gitea to start
wait_for_gitea

# Create a new Gitea user
docker exec gitea su -c '/app/gitea/gitea admin user create --username root --password 2Km11hzZ2 --email root@example.com --admin' git
REGISTRATION_TOKEN=`docker exec gitea su -c '/app/gitea/gitea actions generate-runner-token' git`
export REGISTRATION_TOKEN=$REGISTRATION_TOKEN

echo $REGISTRATION_TOKEN

REGISTRATION_TOKEN=$REGISTRATION_TOKEN docker compose -f gitea-runner.yaml up -d

docker compose -f mysql.yaml up -d
