#!/bin/bash
DOMAIN=$(sed -n '1p' config/main)

docker compose -f watchtower.yaml down
docker compose -f competitors.yaml down
docker compose -f mysql.yaml down
docker compose -f gitea-runner.yaml down
GITEA_HOSTNAME=$DOMAIN docker compose -f gitea.yaml down 
docker compose -f traefik.yaml down

rm -rf ./data