---
title: "Recover root password or failed mount"
description: "Guide to recover root password or failed mount on a Centos 7 instance"
weight: 1
alwaysopen: true
---

## Overview

If you need to set the root password on a Centos 7 instance or fix a faulty /etc/fstab for example, then this is the procedure to access the boot disk without a root password.

## Modify boot parameters

1. Reboot the instance and press "e" when the grub 2 boot menu is shown.

2. Add the following parameters at the end of the `linux16` line:

	`rd.break enforcing=0` 

3. Remove all parameters starting with "console="

4. Press Ctrl+x to boot

## Set password

1. Remount the root filesystem read write.

```shell
$ mount -o remount,rw /sysroot
```
2. You can now edit the root disk files under /sysroot.

2. To set a new password do a change root and set password.

```shell
$ chroot /sysroot
$ passwd
```

3. Exit both shells and the instance will reboot.

```shell
$ exit
```
