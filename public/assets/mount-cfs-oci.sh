#!/bin/bash

IMG=${IMG:=docker.io/library/alpine:latest} 
MNT=${MNT:=/mnt}

podman image exists $IMG || podman image pull $IMG

BASEDIR=/var/lib/containers/storage/overlay
INDEX_FN=$BASEDIR/../overlay-images/images.json
LAYER=$(cat ${INDEX_FN} | jq -r '.[] | select( .names |  any( "$TAG" ) )  | .layer')

mount -t composefs ${BASEDIR}/${LAYER}/composefs-data/composefs.blob -o basedir=${BASEDIR} $MNT
