#!/bin/bash

set -o errexit

main () {
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

run_registry () {
  echo "INFO:
  Starting docker registry.
  "

  docker run \
    --name registry \
    --detach \
    --env "REGISTRY_HTTP_SECRET=wedeploy-secret" \
    --env "REGISTRY_STORAGE=s3" \
    --env "REGISTRY_STORAGE_S3_REGION=sa-east-1" \
    --env "REGISTRY_STORAGE_S3_BUCKET=sample-docker-registry-bucket" \
    --network host \
    registry
}

main
