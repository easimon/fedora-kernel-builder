#!/bin/bash

RPMBUILDDIR=/home/builder/rpmbuild
BUILDVOL=kernelbuild-$(uuidgen)

mkdir -p RPMS

docker build --no-cache -t fedora-kernel-builder .
docker volume create $BUILDVOL
docker run \
  --rm \
  -v $(pwd)/PATCHES:$RPMBUILDDIR/PATCHES \
  -v $(pwd)/RPMS:$RPMBUILDDIR/RPMS \
  -v $BUILDVOL:$RPMBUILDDIR/BUILD \
  fedora-kernel-builder
docker volume rm $BUILDVOL
