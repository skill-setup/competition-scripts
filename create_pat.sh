#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <GITEA_URL> <USERNAME> <PASSWORD>"
    exit 1
fi

# Set variables from script arguments
GITEA_URL="$1"
USERNAME="$2"
PASSWORD="$3"
TOKEN_NAME="CreateOrganizationScript"

# Create a new personal access token
response=$(curl -k -X POST -H "Content-Type: application/json" \
    -u "$USERNAME:$PASSWORD" \
    -d '{
          "name": "'"$TOKEN_NAME"'",
          "scopes": ["read:admin","write:organization,write:repository"]
        }' \
    "$GITEA_URL/api/v1/users/$USERNAME/tokens")

# Extract the token from the response
# new_token=$(echo $response | jq -r '.sha1')
new_token=$(echo "$response" | grep -o '"sha1":"[^"]*"' | sed 's/"sha1":"//;s/"//g')

# Check if the token was successfully created
if [ "$new_token" == "null" ]; then
    echo "Failed to create token. Response: $response"
    exit 1
fi

echo "$new_token"
