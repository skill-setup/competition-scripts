#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <GITEA_TOKEN> <ORG_NAME>"
    exit 1
fi

# Set variables from script arguments
GITEA_TOKEN="$1"
ORG_NAME="$2"
GITEA_URL="https://git.skill17.com/api/v1"

# Create organization
curl -X POST "$GITEA_URL/orgs" \
    -H "Content-Type: application/json" \
    -H "Authorization: token $GITEA_TOKEN" \
    -d '{
        "username": "'"$ORG_NAME"'",
        "full_name": "'"$ORG_NAME"'"
    }'

echo "Organization '$ORG_NAME' created."
