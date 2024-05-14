---
title: "Volume Backup & Restore"
description: "Guide to backup & restore a Volume"
weight: 1
alwaysopen: true
---

## Table of contents

- [Overview](#overview)
- [Horizon backup and restore](#create-volume-backup-from-horizon)
  - [Horizon attach & detach volume](#volume-attach--detach-in-horizon)
- [CLI backup and restore](#volume-backup-using-openstack-cli)
  - [CLI attach & detach volume](#volume-backup-using-openstack-cli)
## Overview

This guide will help you getting started with Volume Backup and Restore in OpenStack's Horizon and CLI.<br/>
Get more information about the [OpenStack command-line client](https://docs.openstack.org/python-openstackclient/ussuri/).


## Create volume backup from Horizon

1. Navigate to ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/) pick the volume you want to backup and choose ```Create Backup```.

![Open-create-backup](/img/openstack-iaas/guides/ops_backup-restore-1.png)




2. In the pop-up window, choose a name and a description for your backup and press ```Create Volume Backup```.

![Create-backup](/img/openstack-iaas/guides/ops_backup-restore-2.png)


3. Check the status of your backup by Navigating to ["Project" → "Volumes" → "Backups"](https://ops.elastx.cloud/project/backups/).
When done, Status will change to available.

![Status-create-backup](/img/openstack-iaas/guides/ops_backup-restore-3.png)

## Restore volume from backup
Backup of a volume can be restored in two ways.
1. Create a new volume manually from the ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/)
2. Have the volume automatically created when restoring from the ["Project" → "Volumes" → "Backups"](https://ops.elastx.cloud/project/backups/).
> **Beware:** If option 2. is chosen, the Availability Zone and Size gets chosen automatically. This means that the volume might be added to a different Availability Zone than intended.

### Option 1. Manually create and restore a backup to a new volume
1. Navigate to ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/) and press ```Create Volume```.

![Status-create-volume](/img/openstack-iaas/guides/ops_backup-restore-4.png)

2. Choose a name and description for the new volume. 
> **Beware:** Volume Size has to be at minimum the size of the backup.
The Volume also has to be in the same Availability Zone as the instance it will be attached too.

![Status-create-volume](/img/openstack-iaas/guides/ops_backup-restore-5.png)

3. Restore by Navigating to ["Project" → "Volumes" → "Backups"](https://ops.elastx.cloud/project/backups/) and press ```Restore Backup```.

![Status-restore-volume](/img/openstack-iaas/guides/ops_backup-restore-6.png)

4. Choose the newly created volume and press ```Restore Backup to Volume```.

![Status-restore-volume](/img/openstack-iaas/guides/ops_backup-restore-7.png)

### Option 2. Automatically create volume and restore to new volume
1. Navigate to ["Project" → "Volumes" → "Backups"](https://ops.elastx.cloud/project/backups/) and press ```Restore Backup```.

![Status-restore-volume](/img/openstack-iaas/guides/ops_backup-restore-6.png)

2. Select ```Create a New Volume``` and press ```Restore Backup to Volume```.

![Status-restore-volume](/img/openstack-iaas/guides/ops_backup-restore-8.png)

3. The restored backup will be available in ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/).

![Status-restore-volume](/img/openstack-iaas/guides/ops_backup-restore-9.png)

## Volume Attach & Detach in Horizon

1. Navigate to ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/) and press the ⬇ arrow next to ```Edit Volume``` on the volume you want to attach and then press ```Manage Attachments``` 

![Status-attach-volume](/img/openstack-iaas/guides/ops_backup-restore-10.png)

2. In the pop-up window choose an instance you want to attach the restored volume to.

![Status-attach-volume](/img/openstack-iaas/guides/ops_backup-restore-11.png)

3. Check volumes again in ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/) to see if the volume is attached to the instance.

![Status-attach-volume](/img/openstack-iaas/guides/ops_backup-restore-12.png)

4. To detach the volume, Navigate to ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/) and press the ⬇ arrow next to ```Edit Volume``` on the volume you want to detach and then press ```Manage Attachments```.
In the pop-up window choose the instance you want to detach the volume from.

![Status-attach-volume](/img/openstack-iaas/guides/ops_backup-restore-13.png)

## Volume Backup using OpenStack CLI

1. List all available volumes: ```openstack volume list```.
```bash
openstack volume list
+--------------------------------------+--------------------------------------+--------+------+-------------------------------------+
| ID                                   | Name                                 | Status | Size | Attached to                         |
+--------------------------------------+--------------------------------------+--------+------+-------------------------------------+
| 3af38568-20fc-4c36-bca4-72555a6761e4 | 3af38568-20fc-4c36-bca4-72555a6761e4 | in-use |   20 | Attached to MyInstance on /dev/vda  |
+--------------------------------------+--------------------------------------+--------+------+-------------------------------------+
```

2. Create backup of your volume: ```openstack volume backup create <Volume ID or Name> --name <Name of Backup> --description <Description of your Backup>```. 
> **Beware:** If the volume is attached to an instance, the flag ```--force``` has to be added.

```bash
openstack volume backup create 3af38568-20fc-4c36-bca4-72555a6761e4 --force --name MyVolumeBackup --description backup_of_my_volume
+-------+--------------------------------------+
| Field | Value                                |
+-------+--------------------------------------+
| id    | 1c06756f-ebe1-4efd-a419-e94184f86fe8 |
| name  | MyVolumeBackup                       |
+-------+--------------------------------------+
```

3. When the creation is finished the backup status will show as: ```available```.

```bash
openstack volume backup list
+--------------------------------------+----------------+---------------------+-----------+------+-------------------+--------------------------------------+---------------+
| ID                                   | Name           | Description         | Status    | Size | Availability Zone | Volume                               | Container     |
+--------------------------------------+----------------+---------------------+-----------+------+-------------------+--------------------------------------+---------------+
| 1c06756f-ebe1-4efd-a419-e94184f86fe8 | MyVolumeBackup | backup_of_my_volume | available |   20 | sto1              | 3af38568-20fc-4c36-bca4-72555a6761e4 | volumebackups |
+--------------------------------------+----------------+---------------------+-----------+------+-------------------+--------------------------------------+---------------+
```

## Volume Restore using OpenStack CLI
1. Create a new volume to restore to from backup:<br/> 
```openstack volume create <ID or Name> --availability-zone <sto1/2/3> --size <GiB> --description <a description>```.

> **Beware:** Volume Size has to be at minimum the size of the backup.
The Volume also has to be in the same Availability Zone as the instance it will be attached too.

```bash
openstack volume create my_volume_restore --availability-zone sto1 --type 16k-iops --size 20 --description restored_from_backup
+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| attachments         | []                                   |
| availability_zone   | sto1                                 |
| bootable            | false                                |
| consistencygroup_id | None                                 |
| created_at          | 2022-05-30T07:18:52.000000           |
| description         | restored_from_backup                 |
| encrypted           | False                                |
| id                  | f63a7a2d-7321-49e3-b909-d49fee733f21 |
| multiattach         | False                                |
| name                | my_volume_restore                    |
| properties          |                                      |
| replication_status  | None                                 |
| size                | 20                                   |
| snapshot_id         | None                                 |
| source_volid        | None                                 |
| status              | creating                             |
| type                | 16k-IOPS                             |
| updated_at          | None                                 |
| user_id             | a2d55d905e05459d84ffd96900c25e9d     |
+---------------------+--------------------------------------+
```

2. Restore backup to the newly created volume: ```openstack volume backup restore  <Backup ID or Name> <Volume ID or Name>```.

```bash
openstack volume backup restore MyVolumeBackup my_volume_restore
+-------------+--------------------------------------+
| Field       | Value                                |
+-------------+--------------------------------------+
| backup_id   | 1c06756f-ebe1-4efd-a419-e94184f86fe8 |
| volume_id   | f63a7a2d-7321-49e3-b909-d49fee733f21 |
| volume_name | my_volume_restore                    |
+-------------+--------------------------------------+
```

3. After the backup is restored, it will show as: ```available```.

```bash
openstack volume list
+--------------------------------------+--------------------------------------+-----------+------+-------------------------------------+
| ID                                   | Name                                 | Status    | Size | Attached to                         |
+--------------------------------------+--------------------------------------+-----------+------+-------------------------------------+
| f63a7a2d-7321-49e3-b909-d49fee733f21 | my_volume_restore                    | available |   20 |                                     |
| 3af38568-20fc-4c36-bca4-72555a6761e4 | 3af38568-20fc-4c36-bca4-72555a6761e4 | in-use    |   20 | Attached to MyInstance on /dev/vda  |
+--------------------------------------+--------------------------------------+-----------+------+-------------------------------------+
```

## Volume Attach & Detach using Openstack CLI

1. List available volumes: ```openstack volume list```.
```bash
openstack volume list
+--------------------------------------+--------------------------------------+-----------+------+-------------------------------------+
| ID                                   | Name                                 | Status    | Size | Attached to                         |
+--------------------------------------+--------------------------------------+-----------+------+-------------------------------------+
| f63a7a2d-7321-49e3-b909-d49fee733f21 | my_volume_restore                    | available |   20 |                                     |
| 3af38568-20fc-4c36-bca4-72555a6761e4 | 3af38568-20fc-4c36-bca4-72555a6761e4 | in-use    |   20 | Attached to MyInstance on /dev/vda  |
+--------------------------------------+--------------------------------------+-----------+------+-------------------------------------+
```

2. List available instances: ```openstack server list```.
```bash
openstack server list
+--------------------------------------+------------+--------+-----------------------------------------+-------+------------+
| ID                                   | Name       | Status | Networks                                | Image | Flavor     |
+--------------------------------------+------------+--------+-----------------------------------------+-------+------------+
| 864db2db-9c19-416e-aa9d-fc7d713db36c | MyInstance | ACTIVE | test-network=192.168.1.9				   |       | v1-micro-1 |
+--------------------------------------+------------+--------+-----------------------------------------+-------+------------+
```

3. Attach your restored volume to an instance: ```openstack server add volume <Instance ID or Name> <Volume ID or Name>```.
```bash
openstack server add volume MyInstance my_volume_restore
```

4. Check to see if your volume is attached to your instance: ```openstack volume list```.
```bash
openstack volume list
+--------------------------------------+--------------------------------------+--------+------+-------------------------------------+
| ID                                   | Name                                 | Status | Size | Attached to                         |
+--------------------------------------+--------------------------------------+--------+------+-------------------------------------+
| f63a7a2d-7321-49e3-b909-d49fee733f21 | my_volume_restore                    | in-use |   20 | Attached to MyInstance on /dev/vdb  |
| 3af38568-20fc-4c36-bca4-72555a6761e4 | 3af38568-20fc-4c36-bca4-72555a6761e4 | in-use |   20 | Attached to MyInstance on /dev/vda  |
+--------------------------------------+--------------------------------------+--------+------+-------------------------------------+
```

5. Detach your volume from an instance: ```server remove volume <Instance ID or Name> <Volume ID or Name>```.
```bash
openstack server remove volume MyInstance my_volume_restore
```

6. Confirm the detachment: ```openstack volume list```.
```bash
openstack volume list
+--------------------------------------+--------------------------------------+-----------+------+-------------------------------------+
| ID                                   | Name                                 | Status    | Size | Attached to                         |
+--------------------------------------+--------------------------------------+-----------+------+-------------------------------------+
| f63a7a2d-7321-49e3-b909-d49fee733f21 | my_volume_restore                    | available |   20 |                                     |
| 3af38568-20fc-4c36-bca4-72555a6761e4 | 3af38568-20fc-4c36-bca4-72555a6761e4 | in-use    |   20 | Attached to MyInstance on /dev/vda  |
+--------------------------------------+--------------------------------------+-----------+------+-------------------------------------+
```
