---
title: "Required xfs mount options"
description: "How to add required mount options for xfs"
weight: 1
alwaysopen: true
---

## Overview

We have discovered that using xfs file system without the required mount options will make the mount fail in case of storage platform rebalance, maintenance or failover.

**When mounting a xfs file system you must mount it with the options `noatime,discard,nobarrier`.**

Note that some cloud images (CentOS 7 for example) have xfs as the default root file system and if you do not use the latest ELASTX provided images you will have to modify the mount options.

Add the mount options to /etc/fstab and reboot or add the mount options online.

```shell
mount -o remount,noatime,discard,nobarrier /mountpoint
```
