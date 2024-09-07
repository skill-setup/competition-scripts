#!/bin/bash

# Gitea instance URL
GITEA_URL='https://git.skill17.com'
# API token with admin rights
API_TOKEN='2c92fc1c82964a53c8bb8dbfcbd506ecb43d983d'

# Loop over the range 00 to 20
for i in $(seq -w 0 20); do
  USERNAME_TO_DISABLE="competitor${i}"

  # Endpoint to get user details
  USER_URL="${GITEA_URL}/api/v1/admin/users/${USERNAME_TO_DISABLE}"

  # Get user details
  USER_DATA=$(curl -s -H "Authorization: token ${API_TOKEN}" -H "Content-Type: application/json" ${USER_URL})

  if [ $? -ne 0 ]; then
    echo "Failed to retrieve details for user '${USERNAME_TO_DISABLE}'."
    continue
  fi

  # Extract current 'active' status
  CURRENT_ACTIVE_STATUS=$(echo ${USER_DATA} | jq '.active')

  if [ "${CURRENT_ACTIVE_STATUS}" == "false" ]; then
    echo "User '${USERNAME_TO_DISABLE}' is already disabled."
    continue
  fi

  # Modify the user data to disable the account
  UPDATED_USER_DATA=$(echo ${USER_DATA} | jq '.active = false')

  # Update user details
  UPDATE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH -H "Authorization: token ${API_TOKEN}" -H "Content-Type: application/json" -d "${UPDATED_USER_DATA}" ${USER_URL})

  if [ ${UPDATE_RESPONSE} -eq 200 ]; then
    echo "User '${USERNAME_TO_DISABLE}' has been disabled successfully."
  else
    echo "Failed to disable user '${USERNAME_TO_DISABLE}'. HTTP status code: ${UPDATE_RESPONSE}"
  fi
done
