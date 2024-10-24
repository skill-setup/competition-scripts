#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <GITEA_URL> <GITEA_TOKEN> <ORG_NAME> <TEAM_NAME> <USERNAME>"
    exit 1
fi

# Set variables from script arguments
GITEA_URL="$1"
GITEA_TOKEN="$2"
ORG_NAME="$3"
TEAM_NAME="$4"
USERNAME="$5"

# API endpoint to get the team ID by name
GET_TEAM_ID_ENDPOINT="$GITEA_URL/api/v1/orgs/$ORG_NAME/teams/search?q=$TEAM_NAME"

# Get the team ID
# team_id=$(curl -s -H "Authorization: token $GITEA_TOKEN" "$GET_TEAM_ID_ENDPOINT" | jq -r ".data[] | select(.name == \"$TEAM_NAME\") | .id")
team_id=$(curl -k -s -H "Authorization: token $GITEA_TOKEN" "$GET_TEAM_ID_ENDPOINT" | awk -F'"id":' '{print $2}' | awk -F',' '{print $1}' | head -n 1)

# Check if the team ID was successfully retrieved
if [ "$team_id" == "null" ]; then
    echo "Failed to retrieve team ID for team '$TEAM_NAME' in organization '$ORG_NAME'."
    exit 1
fi

# API endpoint to add a user to a team
ADD_USER_ENDPOINT="$GITEA_URL/api/v1/teams/$team_id/members/$USERNAME"

# Add the user to the team
response=$(curl -k -s -o /dev/null -w "%{http_code}" -X PUT \
    -H "Content-Type: application/json" \
    -H "Authorization: token $GITEA_TOKEN" \
    "$ADD_USER_ENDPOINT")

# Check if the request was successful
if [ "$response" -ne 204 ]; then
    echo "Failed to add user '$USERNAME' to team '$TEAM_NAME' in organization '$ORG_NAME'. HTTP status code: $response"
    exit 1
fi

# Output success message
echo "User '$USERNAME' added to team '$TEAM_NAME' in organization '$ORG_NAME'."
