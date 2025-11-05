#!/bin/bash

ARCH=$(uname -m)

docker \
  build . \
  --build-arg ARCH=$ARCH \
  -f docker/Dockerfile-rockylinux9-cb-base \
  -t apachecloudberry/apachecloudberry:rockylinux9-cb-base-$ARCH
