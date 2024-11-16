---
author: Shawn Wang
pubDatetime: 2024-10-14
modDatetime: 2024-10-15
title: bootable container
slug: bootc
featured: true
draft: false
tags:
  - bootc
  - composefs
  - podman
description:
  Boot your OS from OCI image

---

# Immutable solutions

Upgrade system always is a pain point for me, especially with package manager systems.
They could work just sometime accident might happen, then need a lot of human operation to fix it.

There are lots of immutable solutions for os upgrade.

## solution concepts:
- A/B switch
  -  systemd usr-merge
- file system snapshot
- oci image

## solutions:
- ubuntu snap
- nixos
- talos
- bootc/ostree
- elemental-toolkit

## OCI ecosystem

- container engine - podman
  - build / pull images

# bootc - bootable container


- ostree
- composefs

bootc as a bootable container runtime but it not really a runtime, more like a deployer.

https://github.com/containers/bootc

I really like bootc concept and thought it would the next `docker`.


## podman with composefs as storage backend

[Composefs state of the union](https://blogs.gnome.org/alexl/2023/07/11/composefs-state-of-the-union/)

https://github.com/containers/storage/pull/1646


https://github.com/containers/storage/blob/main/docs/containers-storage-composefs.md

containers-storage.conf /etc/containers/storage.conf

```

pull_options = {enable_partial_images = "true", use_hard_links = "true", ostree_repos="",  convert_images = "true"}

[storage.options.overlay]
use_composefs = "true"

```

```
[storage.options.pull_options]
convert_images = "true"
```

* [mount-cfs-oci.sh](/assets/mount-cfs-oci.sh)

```bash
#!/bin/bash

TAG=${TAG:=docker.io/library/alpine:latest} 
MNT=${MNT:=/mnt}

BASEDIR=/var/lib/containers/storage/overlay
INDEX_FN=$BASEDIR/../overlay-images/images.json


LAYER=$(cat ${INDEX_FN} | jq -r '.[] | select( .names |  any( "$TAG" ) )  | .layer')

mount -t composefs ${BASEDIR}/${LAYER}/composefs-data/composefs.blob -o basedir=${BASEDIR} $MNT
```


```
$ podman pull quay.io/centos-bootc/centos-bootc:stream9
$ podman image save quay.io/centos-bootc/centos-bootc:stream9 -o stream9.tar #(oci)

# podman image mount  quay.io/centos-bootc/centos-bootc:stream9
/var/lib/containers/storage/overlay/98cf94224120f2355d5efc4df25632f6789c3b251f52cc0893562f959d72a7f6/merged
# mkcomposefs /var/lib/containers/storage/overlay/98cf94224120f2355d5efc4df25632f6789c3b251f52cc0893562f959d72a7f6/merged --digest-store=/sysroot/composefs/repo /sysroot/composefs/images/bootc-cs9.cfs

# mount -o rw,remount /sysroot/
# initrd
#mount --bind /sysroot /sysroot.tmp

Containerfile `ln -s sysroot/composefs composefs`


mkdir /sysroot.tmp
mount /dev/vda3 /sysroot.tmp

mount -t composefs /sysroot.tmp/composefs/images/bootc-cs9.cfs -o basedir=/sysroot/composefs/repo /sysroot

mount --bind /sysroot.tmp/ostree/deploy/default/deploy/37595a2f96fc23131eef6af87920858e6eecc4de5540ef3278aa7e184c7d4d5c.0/etc /sysroot/etc
mount --bind /sysroot.tmp/ostree/deploy/default/var /sysroot/var

modprobe zram
modprobe xfs
```
