#!/bin/bash

# docker-compose -f network.yml up
docker-compose -f gitea.yaml down
docker-compose -f gitea-runner.yaml down

rm -rf ./data
