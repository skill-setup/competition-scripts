#!/bin/bash

# Read the username and password from the config/main file
DOMAIN=$(sed -n '1p' config/main)
USERNAME=$(sed -n '2p' config/main)
PASSWORD=$(sed -n '3p' config/main)
MODULES=$(sed -n '4p' config/main)

export GITEA_HOSTNAME=$DOMAIN

# create various config and creation files
# Start Traefik and Gitea using Docker Compose
docker compose -f traefik.yaml up -d --remove-orphans
GITEA_HOSTNAME=$DOMAIN docker compose -f gitea.yaml up -d

# Wait for Gitea to start
function wait_for_gitea() {
  local retries=10
  local wait=3
  local count=0

  until curl -k -s https://git.$DOMAIN/api/v1/version > /dev/null; do
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
USERNAME=$USERNAME PASSWORD=$PASSWORD DOMAIN=$DOMAIN docker compose -f watchtower.yaml up -d

#### START GTI PREP
GITEA_URL="https://git.$DOMAIN"
GITEA_TOKEN=$(./create_pat.sh "https://git.$DOMAIN" "$USERNAME" "$PASSWORD")

# create org for demo repos
response=$(curl -s -k -X POST "$GITEA_URL/api/v1/orgs" \
    -H "Content-Type: application/json" \
    -H "Authorization: token $GITEA_TOKEN" \
    -d '{
        "username": "frameworks",
        "full_name": "frameworks"
    }')

./create_organisation.sh $GITEA_TOKEN $GITEA_URL "images"
./create_organisation.sh $GITEA_TOKEN $GITEA_URL "frameworks"

./create_team.sh $GITEA_TOKEN $GITEA_URL "frameworks" "competitors" false

./import_framework.sh $GITEA_TOKEN $GITEA_URL "https://github.com/iwtsc/laravel-base.git" "laravel"
./import_framework.sh $GITEA_TOKEN $GITEA_URL "https://github.com/on-lick/vuejs.git" "vuejs"

docker pull nginx:latest > /dev/null 2>&1
docker login -u $USERNAME -p $PASSWORD git.$DOMAIN > /dev/null 2>&1

# Generate competitors.yaml
cat <<EOF > competitors.yaml
services:
EOF

# initialize the basic modules
tail -n +5 config/main | while read -r user pass sub; do

    docker exec gitea su -c '/app/gitea/gitea admin user create --username '$user' --password '$pass' --email '$user@example.com' --must-change-password=false' git

  for module in $MODULES; do
    echo "Processing module: $module for $user"

  cat <<EOF >> competitors.yaml
  ${user}_${module}:
    image: git.${DOMAIN}/${user}/${module}:latest
    container_name: ${user}_${module}
    restart: always
    networks:
      - gitea
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.comp01_module_a.rule=Host(\`${sub}-${module}.$DOMAIN\`)"
      - "traefik.http.routers.comp01_module_a.entrypoints=websecure"
      - "traefik.http.routers.comp01_module_a.tls=true"
      - "traefik.http.services.comp01_module_a.loadbalancer.server.port=80"
      - "com.centurylinklabs.watchtower.enable=true"
EOF
    
    ./add_user_to_team.sh $GITEA_URL $GITEA_TOKEN "frameworks" "competitors" ${user}

    echo "pushing inital container"
    docker tag nginx:latest git.$DOMAIN/$user/$module
    docker push git.$DOMAIN/$user/$module
  done
done

cat <<EOF >> competitors.yaml

networks:
  gitea:
    external: true
EOF

docker compose -f competitors.yaml up -d 
