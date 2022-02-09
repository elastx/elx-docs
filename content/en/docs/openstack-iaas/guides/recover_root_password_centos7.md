---
title: "Recover root password or failed mount"
description: "Guide to recover root password or failed mount on a Centos 7 instance"
weight: 1
alwaysopen: true
---

## Overview

If you need to set the root password on a Centos 7 instance or fix a faulty /etc/fstab for example, then this is the procedure to access the boot disk without a root password.

## Modify boot parameters

Reboot the instance and press "e" when the grub 2 boot menu is shown.

Add the following parameters at the end of the `linux16` line:

`rd.break enforcing=0` 

and remove all parameters starting with "console="

Press Ctrl+x to boot

## Set password

Remount the root filesystem read write

```shell
$ mount -o remount,rw /sysroot 
```

Now you can edit the root disk files under /sysroot.

If you want to set a new password do a change root and set password.

```shell
$ chroot /sysroot 
```

```shell
$ passwd 
```

Exit both shells and the instance will reboot.

```shell
$ exit
```
