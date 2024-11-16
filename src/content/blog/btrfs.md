---
author: Shawn Wang
pubDatetime: 2024-11-16
title: btrfs
slug: btrfs
tags:
  - btrfs
description:
  btrfs add device

---

# Oh... my root is almost full, let me extend it.

I made a specieal configuration for my L14 laptop, small ssd 256G and large memory 64G.
In order to limit my storage usage, I keep less important data in tmpfs.

```
UUID=3c6b0688-169e-4fce-8bfe-dc95771930bb /                       btrfs   subvol=root,compress=zstd:1 0 0
UUID=a21c4ae9-9398-4d80-93e1-6231c8fc8247 /boot                   ext4    defaults        1 2
UUID=4677-9C71          /boot/efi               vfat    umask=0077,shortname=winnt 0 2
UUID=3c6b0688-169e-4fce-8bfe-dc95771930bb /home                   btrfs   subvol=home,compress=zstd:1 0 0

tmpfs   /tmp                                                      tmpfs   rw,nodev,nosuid,size=2G          0  0
tmpfs   /var/cache/dnf                                            tmpfs   rw,nodev,nosuid,size=5G          0  0
tmpfs   /var/lib/containers                                       tmpfs   rw,nodev,nosuid,size=40G          0  0
tmpfs   /home/shawn/.cargo/registry                               tmpfs   rw,nodev,size=5G,uid=shawn,gid=shawn          0  0
tmpfs   /home/shawn/.cache                                        tmpfs   rw,nodev,size=5G,uid=shawn,gid=shawn          0  0
tmpfs   /home/shawn/Downloads                                     tmpfs   rw,nodev,size=5G,uid=shawn,gid=shawn          0  0
```

But, it is time for me to face the running out of disk space problem.

## plan

- add device
- migrate rootfs as bootc, composefs

## Bye, bye, windows

As beginning, I thought keep windows to run some experimental programs, like wsl2.
However, when I really try to run windows, it ask me about something like recovery key.
So, the useless windows been more useless.

## btrfs add device

```
fdisk /dev/nvme0n1
btrfs device add /dev/nvme0n1p2 /
btrfs balance start -dconvert=single -mconvert=raid1 /
```

### data single, meta-data raid1


## nocow

## scrub - validates the metadata and data
btrfs scrub status /
