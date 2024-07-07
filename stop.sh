#!/bin/bash

docker compose -f gitea-runner.yaml down
docker compose -f gitea.yaml down
docker compose -f traefik.yaml down

rm -rf ./data
