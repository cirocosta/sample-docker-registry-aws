# -*- mode: yaml -*-
# vi: set ft=yaml :
# 
# Template of a registry configuration.
# 
# It expects the folling variables:
# - region: AWS region where the S3 bucket is deployed to; and
# - bucket: the name of the bucket to push registry data to.
#
# Without modifying the default command line arguments of the
# registry image, put this configuration under 
# `/etc/docker/registry/config.yml`.
version: 0.1
log:
  level: "debug"
  formatter: "json"
  fields:
    service: "registry"
storage:
  cache:
    blobdescriptor: "inmemory"
  s3:
    region: "${region}"
    bucket: "${bucket}"
http:
  addr: ":5000"
  secret: "a-secret"
  debug:
    addr: ":5001"
    # In the `master` branch there's already native support for
    # prometheus metrics.
    # 
    # If you want to make use of this feature: 
    # 1. clone `github.com/docker/distribution`;
    # 2. build the image (`docker build -t registry .`);
    # 3. reference the recently built image in the initialization.
    prometheus:
      enabled: true
      path: "/metrics"
  headers:
    X-Content-Type-Options: [ "nosniff" ]
health:
  storagedriver:
    enabled: true
    interval: "10s"
    threshold: 3
