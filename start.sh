#!/bin/bash

docker compose -f traefik.yaml start
docker compose -f gitea.yaml start
docker compose -f gitea-runner.yaml start
docker compose -f mysql.yaml start

