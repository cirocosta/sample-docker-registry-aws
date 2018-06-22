#!/bin/bash

# Setups the registry machine to have a running
# Docker registry that makes use of the instance
# profile set in the machine to authenticate
# against the S3 bucket set for storing registry's
# data.

set -o errexit
set -o nounset

main() {
  install_docker
  run_registry
}

install_docker() {
  echo "INFO:
  Installing docker.
  "

  curl -fsSL get.docker.com -o get-docker.sh
  sudo sh ./get-docker.sh
}

run_registry() {
  echo "INFO:
  Starting docker registry.

  REGION=${region}
  BUCKET=${bucket}
  "

  docker run \
    --name registry \
    --detach \
    --env "REGISTRY_HTTP_SECRET=a-secret" \
    --env "REGISTRY_STORAGE=s3" \
    --env "REGISTRY_STORAGE_S3_REGION=${region}" \
    --env "REGISTRY_STORAGE_S3_BUCKET=${bucket}" \
    --network host \
    registry
}

main
