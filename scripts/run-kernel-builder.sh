#!/bin/bash

set -eu

pwd
df -h
docker info

BUILDID=$(uuidgen)
RPMBUILDDIR=/home/builder/rpmbuild
BUILDVOL=kernelbuild-$BUILDID

mkdir -p RPMS SRPMS BUILD

docker build --no-cache -t fedora-kernel-builder:$BUILDID .
docker volume create $BUILDVOL

docker run \
  --rm \
  -v $(pwd)/PATCHES:$RPMBUILDDIR/PATCHES \
  -v $(pwd)/RPMS:$RPMBUILDDIR/RPMS \
  -v $(pwd)/BUILD:$RPMBUILDDIR/BUILD \
  fedora-kernel-builder:$BUILDID
docker volume rm $BUILDVOL
docker image rm fedora-kernel-builder:$BUILDID
