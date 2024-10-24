#!/bin/bash
DOMAIN=$(sed -n '1p' config/main)

docker compose -f watchtower.yaml down
docker compose -f competitors.yaml down
docker compose -f mysql.yaml down
docker compose -f gitea-runner.yaml down
GITEA_HOSTNAME=$DOMAIN docker compose -f gitea.yaml down 
docker compose -f traefik.yaml down

# delete all volumes from the containers
rm -rf ./data

# go through all competitors and remove all images
tail -n +5 config/main | while read -r user pass sub; do
  echo $user
  docker images | grep $user | awk '{print $3}' | xargs docker rmi -f
done