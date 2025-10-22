#!/bin/bash
# ============================
# generate-runners.sh
# Dynamically generate Gitea runners in a docker-compose.yml file
# Usage: ./generate-runners.sh <number_of_runners>
# Example: ./generate-runners.sh 6
# ============================

set -e

NUM_RUNNERS=$1

if [[ -z "$NUM_RUNNERS" || "$NUM_RUNNERS" -lt 1 ]]; then
  echo "Usage: $0 <number_of_runners>"
  exit 1
fi

OUTPUT_FILE="gitea-runner.yaml"

cat > "$OUTPUT_FILE" <<EOF
services:
  runner1: &runner
    image: gitea/act_runner:latest
    networks:
      - gitea
    environment: &runner_env
      CONFIG_FILE: /config.yaml
      GITEA_INSTANCE_URL: "http://gitea:3000"
      GITEA_RUNNER_REGISTRATION_TOKEN: "\${REGISTRATION_TOKEN}"
      GITEA_RUNNER_NAME: "Runner 1"
    restart: always
    volumes:
      - ./config/gitea-runner/config.yaml:/config.yaml
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data/runner1:/data
EOF

# Generate remaining runners
for i in $(seq 2 "$NUM_RUNNERS"); do
cat >> "$OUTPUT_FILE" <<EOF

  runner${i}:
    <<: *runner
    environment:
      <<: *runner_env
      GITEA_RUNNER_NAME: "Runner ${i}"
    restart: always
    volumes:
      - ./config/gitea-runner/config.yaml:/config.yaml
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data/runner${i}:/data
EOF
done

cat >> "$OUTPUT_FILE" <<EOF

networks:
  gitea:
    external: true
EOF

echo "✅ Generated $OUTPUT_FILE with $NUM_RUNNERS runners."
