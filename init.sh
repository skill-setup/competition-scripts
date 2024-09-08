#!/bin/bash

for i in $(seq -w 00 20); do
  docker tag nginx:latest git.skill17.com/competitor$i/backend:latest
  docker tag nginx:latest git.skill17.com/competitor$i/frontend:latest

  docker push git.skill17.com/competitor$i/backend:latest
  docker push git.skill17.com/competitor$i/frontend:latest
done
