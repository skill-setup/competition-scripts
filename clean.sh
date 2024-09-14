#!/bin/bash

docker compose -f watchtower.yaml down
docker compose -f competitors.yaml down
docker compose -f mysql.yaml down
docker compose -f gitea-runner.yaml down
docker compose -f gitea.yaml down 
docker compose -f traefik.yaml down

rm -rf ./data


