#!/bin/bash

docker compose -f gitea-runner.yaml stop 
GITEA_HOSTNAME=$DOMAIN docker compose -f gitea.yaml stop 
docker compose -f traefik.yaml stop 
docker compose -f watchtower.yaml stop
docker compose -f verdaccio.yaml stop
