#!/bin/bash

ARCH=$(uname -m)

docker \
  build . \
  --build-arg ARCH=$ARCH \
  -f docker/Dockerfile-rockylinux8-cb-base \
  -t apachecloudberry/apachecloudberry:rockylinux8-cb-base-$ARCH
