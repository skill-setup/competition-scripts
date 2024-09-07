#!/bin/bash

# Read the username and password from the config/passwd file
USERNAME=$(sed -n '1p' config/passwd)
PASSWORD=$(sed -n '2p' config/passwd)

# Start Traefik and Gitea using Docker Compose
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

# Create a new Gitea user using the username and password from the passwd file
docker exec gitea su -c "/app/gitea/gitea admin user create --username $USERNAME --password $PASSWORD --email $USERNAME@example.com --admin" git

# Generate a registration token for the Gitea runner
REGISTRATION_TOKEN=$(docker exec gitea su -c '/app/gitea/gitea actions generate-runner-token' git)
export REGISTRATION_TOKEN=$REGISTRATION_TOKEN

echo "Registration Token: $REGISTRATION_TOKEN"

# Start the Gitea runner with the registration token
REGISTRATION_TOKEN=$REGISTRATION_TOKEN docker compose -f gitea-runner.yaml up -d

# Start MySQL
docker compose -f mysql.yaml up -d
