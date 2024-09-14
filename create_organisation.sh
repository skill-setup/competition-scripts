#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <GITEA_TOKEN> <GITEA_URL> <ORG_NAME>"
    exit 1
fi

# Set variables from script arguments
GITEA_TOKEN="$1"
GITEA_URL="$2"
ORG_NAME="$3"

# Create organization
curl -k -X POST "$GITEA_URL/api/v1/orgs" \
    -H "Content-Type: application/json" \
    -H "Authorization: token $GITEA_TOKEN" \
    -d '{
        "username": "'"$ORG_NAME"'",
        "full_name": "'"$ORG_NAME"'"
    }'

echo "Organization '$ORG_NAME' created."
