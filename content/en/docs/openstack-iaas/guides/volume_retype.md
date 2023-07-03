---
title: "Volume Retype"
description: "Guide to change volume type"
weight: 1
alwaysopen: true
---

## Overview

This guide will help you getting started with changing volume type in OpenStack's Horizon and CLI, by using the retype function. 

> Note: For volumes with -enc suffix it is required to work with the volume in detached mode

In this example, we will use a detached volume with the type ```16k-IOPS-enc```.
Get more information about the [OpenStack command-line client](https://docs.openstack.org/python-openstackclient/train/).

## Volume retype from Horizon

Navigate to ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/) choose the volume you want to retype and press the ⬇ arrow next to ```Edit Volume``` and select ```Change Volume Type```.

![Open-create-backup](/img/openstack-iaas/guides/ops_volume-retype-1.png)


### Choose Type

In the pop-up window, choose a new type and set Migration Policy to ```On Demand```.

![Create-backup](/img/openstack-iaas/guides/ops_volume-retype-2.png)

<br/>
<br/>

### Check status

The volume status will change to ```retyping```, this can take a while depending on the volume size.
After everything is done, the volume will have the status ```available```.

![Status-create-backup](/img/openstack-iaas/guides/ops_volume-retype-4.png)



## Volume retype using OpenStack CLI

List all available volumes: ```openstack volume list --long```.
```bash
openstack volume list --long
+--------------------------------------+------------------+-----------+------+--------------+----------+--------------------------------------+--------------------------------------+
| ID                                   | Name             | Status    | Size | Type         | Bootable | Attached to                          | Properties                           |
+--------------------------------------+------------------+-----------+------+--------------+----------+--------------------------------------+--------------------------------------+
| ad2ca224-78e0-4930-941e-596bbea05b95 | encrypted-volume | available |    1 | 16k-IOPS-enc | false    |                                      |                                      |
| db329723-1a3e-4fb9-be07-da6e0a5ff0b1 |                  | in-use    |   20 | 4k-IOPS      | true     | Attached to docker-test on /dev/vda  | attached_mode='rw', readonly='False' |
+--------------------------------------+------------------+-----------+------+--------------+----------+--------------------------------------+--------------------------------------+
```

Retype volume with: ```openstack volume set --type <volume-type> --retype-policy on-demand <Volume ID or Name>```.

```bash
openstack volume set --type 16k-IOPS --retype-policy on-demand ad2ca224-78e0-4930-941e-596bbea05b95

openstack volume list --long
+--------------------------------------+------------------+----------+------+--------------+----------+--------------------------------------+--------------------------------------+
| ID                                   | Name             | Status   | Size | Type         | Bootable | Attached to                          | Properties                           |
+--------------------------------------+------------------+----------+------+--------------+----------+--------------------------------------+--------------------------------------+
| ad2ca224-78e0-4930-941e-596bbea05b95 | encrypted-volume | retyping |    1 | 16k-IOPS-enc | false    |                                      |                                      |
| db329723-1a3e-4fb9-be07-da6e0a5ff0b1 |                  | in-use   |   20 | 4k-IOPS      | true     | Attached to docker-test on /dev/vda  | attached_mode='rw', readonly='False' |
+--------------------------------------+------------------+----------+------+--------------+----------+--------------------------------------+--------------------------------------+
```

When retyping is done, status will be shown as: ```available```.

```bash
openstack volume list --long
+--------------------------------------+------------------+-----------+------+----------+----------+--------------------------------------+--------------------------------------+
| ID                                   | Name             | Status    | Size | Type     | Bootable | Attached to                          | Properties                           |
+--------------------------------------+------------------+-----------+------+----------+----------+--------------------------------------+--------------------------------------+
| ad2ca224-78e0-4930-941e-596bbea05b95 | encrypted-volume | available |    1 | 16k-IOPS | false    |                                      |                                      |
| db329723-1a3e-4fb9-be07-da6e0a5ff0b1 |                  | in-use    |   20 | 4k-IOPS  | true     | Attached to docker-test on /dev/vda  | attached_mode='rw', readonly='False' |
+--------------------------------------+------------------+-----------+------+----------+----------+--------------------------------------+--------------------------------------+
```


