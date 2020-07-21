#!/bin/bash

# maximise space available for docker by combining free space on temp and os disk

# how much space to leave free on root volume, in KB (for non-docker usage)
FREE_RESERVE_KB=$(expr 512 \* 1024)

# free current docker image space
sudo systemctl stop docker
sudo rm -rf /var/lib/docker && sudo mkdir -p /var/lib/docker

# gather sizes
TMP_DEV=$(df --output=source  /mnt/ | tail -1)
ROOT_FREE_KB=$(df --block-size=1024 --output=avail / | tail -1)
ROOT_LVM_SIZE_KB=$(expr $ROOT_FREE_KB - $FREE_RESERVE_KB)
ROOT_LVM_SIZE_BYTES=$(expr $ROOT_LVM_SIZE_KB \* 1024)

# convert temp disk into LVM PV
sudo swapoff -a
sudo umount /mnt
sudo pvcreate -f $TMP_DEV

# create large file for LVM on root partition
sudo touch /pv
sudo fallocate -z -l $ROOT_LVM_SIZE_BYTES /pv
ROOT_LOOP_DEV=$(sudo losetup --find --show /pv)
sudo pvcreate -f $ROOT_LOOP_DEV

# create LVM volume group
sudo vgcreate buildvg $TMP_DEV $ROOT_LOOP_DEV

# re-create swap on volume group
#sudo lvcreate -L2G -n swap buildvg
#sudo mkswap /dev/mapper/buildvg-swap
#sudo swapon /dev/mapper/buildvg-swap

# create LV with complete remaining space
sudo lvcreate -l100%FREE -n buildlv buildvg
sudo mkfs.ext4 /dev/mapper/buildvg-buildlv

# mount volume for docker image space
sudo mount /dev/mapper/buildvg-buildlv /var/lib/docker

sudo systemctl start docker

# memory and disk space report
free
df -h
