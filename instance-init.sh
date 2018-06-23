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

# Installs the latest `docker-ce` from `apt` using
# the installation script provided by the folks
# at Docker.
install_docker() {
  echo "INFO:
  Installing docker.
  "

  curl -fsSL get.docker.com -o get-docker.sh
  sudo sh ./get-docker.sh
}

# Runs the registry making use of the registry configuration
# that should exist under `/etc/registry.yml`.
#
# Such configuration must be placed before running this one.
run_registry() {
  echo "INFO:
  Starting docker registry.
  "

  if [[ ! -f "/etc/registry.yml" ]]; then
    echo "ERROR:
  File /etc/registry.yml does not exist.
  "
    exit 1
  fi

docker run \
  --name registry \
  --detach \
  --network host \
  --volume /etc/registry.yml:/etc/docker/registry/config.yml \
  registry
}

main
