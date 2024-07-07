# create competitor users
docker exec gitea su -c '/app/gitea/gitea admin user create --username competitor1 --password password --email competitor1@example.com --must-change-password=false' git

# create repos for competitors

# should i create the ssh key as well?

