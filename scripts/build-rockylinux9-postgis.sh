#!/bin/bash

ARCH=$(uname -m)

docker \
  build . \
  --build-arg ARCH=$ARCH \
  -f docker/Dockerfile-rockylinux9-postgis \
  -t apachecloudberry/apachecloudberry:rockylinux9-postgis-$ARCH 
