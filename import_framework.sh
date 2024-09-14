#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <GITEA_TOKEN> <DOMAIN> <GITHUB_URL> <REPO_NAME>"
    exit 1
fi

# Set variables from script arguments
GITEA_TOKEN=$1
DOMAIN=$2
GITHUB_URL=$3
REPO_NAME=$4

# Print variables for debugging
echo "GITEA_TOKEN: $GITEA_TOKEN"
echo "DOMAIN: $DOMAIN"
echo "GITHUB_URL: $GITHUB_URL"
echo "REPO_NAME: $REPO_NAME"

# Migrate repository
response=$(curl -k -X POST "$DOMAIN/api/v1/repos/migrate" \
-H "Authorization: token $GITEA_TOKEN" \
-H "Content-Type: application/json" \
-d '{
  "clone_addr": "'"$GITHUB_URL"'",
  "repo_owner": "frameworks",
  "repo_name": "'"$REPO_NAME"'",
  "mirror": false,
  "private": false,
  "template": true
}')

# Output response for debugging
echo "..done!