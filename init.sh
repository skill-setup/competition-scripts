#!/bin/bash

# Read the username and password from the config/main file
DOMAIN=$(sed -n '1p' config/main)
MODULES=$(sed -n '2p' config/main)
USERNAME=$(sed -n '3p' config/main)
PASSWORD=$(sed -n '4p' config/main)

# create various config and creation files
# Start Traefik and Gitea using Docker Compose
docker compose -f traefik.yaml up -d --remove-orphans
GITEA_HOSTNAME=$DOMAIN docker compose -f gitea.yaml up -d

# Wait for Gitea to start
function wait_for_gitea() {
  local retries=15
  local wait=3
  local count=0

  until curl -s http://localhost:3000/api/v1/version > /dev/null; do
    if [ $count -ge $retries ]; then
      echo "Gitea did not become ready in time."
      exit 1
    fi
    echo "Waiting for Gitea to be ready..."
    sleep $wait
    count=$((count + 1))
  done
}

# Wait for Gitea to start
wait_for_gitea

# Create a new Gitea user using the username and password from the passwd file
docker exec gitea su -c "/app/gitea/gitea admin user create --username $USERNAME --password $PASSWORD --email $USERNAME@example.com --admin" git

# Generate a registration token for the Gitea runner
REGISTRATION_TOKEN=$(docker exec gitea su -c '/app/gitea/gitea actions generate-runner-token' git)
export REGISTRATION_TOKEN=$REGISTRATION_TOKEN

echo "Registration Token: $REGISTRATION_TOKEN"

# Start the Gitea runner with the registration token
REGISTRATION_TOKEN=$REGISTRATION_TOKEN docker compose -f gitea-runner.yaml up -d

# Start MySQL
docker compose -f mysql.yaml up -d 

# Start watchtower
docker compose -f watchtower.yaml up -d

#### START GTI PREP
GITEA_URL="https://git.$DOMAIN"
GITEA_TOKEN=$(./create_pat.sh "https://git.$DOMAIN" "$USERNAME" "$PASSWORD")

# create org for demo repos
curl -k -X POST "$GITEA_URL/api/v1/orgs" \
    -H "Content-Type: application/json" \
    -H "Authorization: token $GITEA_TOKEN" \
    -d '{
        "username": "frameworks",
        "full_name": "frameworks"
    }'

./create_organisation.sh $GITEA_TOKEN $GITEA_URL "images"
./create_organisation.sh $GITEA_TOKEN $GITEA_URL "frameworks"

./import_frameworks.sh $GITEA_TOKEN $GITEA_URL "https://github.com/iwtsc/laravel-base.git" "laravel-base"
./import_frameworks.sh $GITEA_TOKEN $GITEA_URL "https://github.com/iwtsc/vuejs-base.git" "vuejs-base"




# Generate competitors.yaml
cat <<EOF > competitors.yaml
version: '3.8'

services:
EOF


# initialize the basic modules
tail -n +5 config/main | while read -r user pass sub; do

  echo $user $pass $sub
  docker exec gitea su -c '/app/gitea/gitea admin user create --username '$user' --password '$pass' --email '$user@example.com' --must-change-password=false' git

  for module in $MODULES; do
    echo "Processing module: $module for $user"

    cat <<EOF >> competitors.yaml
  ${user}_${module}:
    image: nginx:latest
    container_name: ${user}_${module}
    restart: always
    networks:
      - gitea
    labels:
      traefik.enable: 'true'
      traefik.http.routers.${user}_${module}.rule: Host(\`${sub}${module}.$DOMAIN\`)
    volumes:
      - ./data/${user}/${module}:/usr/share/nginx/html
EOF
    
    # Example Docker commands using both competitor and module variables
#    docker tag nginx:latest $DOMAIN/competitor$i/$module:latest
#    docker push $DOMAIN/competitor$i/$module:latest
  done

#  docker tag nginx:latest git.skill17.com/competitor$i/backend:latest
#  docker tag nginx:latest git.skill17.com/competitor$i/frontend:latest

#  docker push git.skill17.com/competitor$i/backend:latest
#  docker push git.skill17.com/competitor$i/frontend:latest
done

cat <<EOF >> competitors.yaml

networks:
  gitea:
    external: true
EOF

docker compose -f competitors.yaml up -d 
