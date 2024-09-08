#!/bin/bash

docker compose -f gitea-runner.yaml stop 
docker compose -f gitea.yaml stop 
docker compose -f traefik.yaml stop 

