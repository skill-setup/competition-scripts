#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 6 ]; then
    echo "Usage: $0 <GITEA_TOKEN> <USERNAME> <PASSWORD> <GITEA_URL> <GITHUB_URL> <REPO_NAME>"
    exit 1
fi

# Set variables from script arguments
GITEA_TOKEN=$1
USERNAME=$2
PASSWORD=$3
GITEA_URL=$4
GITHUB_URL=$5
REPO_NAME=$6
WORKFLOW_FILE='docker-ci.yml'
ORG_NAME='frameworks'

# Clone the repository
git clone "$GITHUB_URL" "$REPO_NAME"
cd "$REPO_NAME" || exit

# Replace the URL in the GitHub Action file
# sed -i '' "s|git.local.skill17.com|$GITEA_URL|g" ".github/workflows/$WORKFLOW_FILE"
sed -i "s|git.local.skill17.com|$GITEA_URL|g" ".github/workflows/$WORKFLOW_FILE"

# Configure git
git config user.name "Franz Bot"
git config user.email "franz@skill17.com"

# Commit the changes
git add ".github/workflows/$WORKFLOW_FILE"
git commit -m "Update Docker registry URL in GitHub Action"

# Create the repository on Gitea under the "frameworks" organization
create_repo_response=$(curl -s -X POST "https://$GITEA_URL/api/v1/orgs/$ORG_NAME/repos" \
-H "Authorization: token $GITEA_TOKEN" \
-H "Content-Type: application/json" \
-d '{
  "name": "'"$REPO_NAME"'",
  "private": false,
  "template": true
}')

# Check if the repository was created successfully
if echo "$create_repo_response" | grep -q '"id":'; then
    echo "Repository $REPO_NAME created in the $ORG_NAME organization on Gitea."
else
    echo "Failed to create repository on Gitea: $create_repo_response"
    exit 1
fi

# Add Gitea remote and push the changes
git remote add gitea "https://$USERNAME:$PASSWORD@$GITEA_URL/$ORG_NAME/$REPO_NAME.git"
git push gitea main

# Output response for debugging
echo "Repository $REPO_NAME pushed to the $ORG_NAME organization on Gitea with updated GitHub Action!"
