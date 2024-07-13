#!/bin/bash
# prepare jq command 
apt-get install -y jq

GITEA_URL='https://git.skill17.com'

# create personal access token
PAT=$(./create_pat.sh $GITEA_URL root '2Km11hzZ2')
echo $PAT

# create organisations
./create_organisation.sh $PAT images
./create_organisation.sh $PAT frameworks 
./create_organisation.sh $PAT competitionc

# create competitor users
#docker exec gitea su -c '/app/gitea/gitea admin user create --username competitor1 --password password --email competitor1@example.com --must-change-password=false' git

# create repos for competitors

# should i create the ssh key as well?

# create databases for users
