---
title: "Volume Backup / Restore"
description: "Guide to backup/restore a Volume"
weight: 1
alwaysopen: true
---

## Overview

This guide will help you getting started with Volume Backup and Restore in OpenStack's Horizon and CLI.<br/>
More information about the [OpenStack command-line client](https://docs.openstack.org/python-openstackclient/train/).

## Create volume backup from Horizon

Navigate to ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/) choose the volume you want to backup and choose "Create Backup".

![Open-create-backup](/img/openstack-iaas/guides/open_create-backup-1.png)


#### Choose Backup Name

In the pop-up window, choose a name and a description for your backup and press Create Volume Backup.

![Create-backup](/img/openstack-iaas/guides/open_create-backup-2.png)

<br/>
<br/>

### Check the status of your backup

Navigate to ["Project" → "Volumes" → "Backups"](https://ops.elastx.cloud/project/backups/) to see the status of the volume.

![Status-create-backup](/img/openstack-iaas/guides/open_create-backup-3.png)

## Restore volume from backup
Backup of a volume can be restored in two ways, one way is to create a new volume manually from the ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/), or to have the volume automatically created when restoring from the ["Project" → "Volumes" → "Backups"](https://ops.elastx.cloud/project/backups/).
> **Beware:** If option two is chosen, the Availability-Zone and Size gets chosen automaically. This means that the volume might be added to a different Availability-Zone than intended.

### Manually Create a new volume and restore a backup to that volume
Navigate to ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/) and press create new volume.

![Status-create-volume](/img/openstack-iaas/guides/create_new_volume.png)

Choose a name and description for the new volume. 
> **Beware:** Volume Size has to be at minimum the size of the backup.
The Volume also has to be in the same Availability-zone as the instance it will be attached too.

![Status-create-volume](/img/openstack-iaas/guides/create_new_volume-2.png)

#### Restore

Navigate to ["Project" → "Volumes" → "Backups"](https://ops.elastx.cloud/project/backups/) and press Restore Backup.

![Status-restore-volume](/img/openstack-iaas/guides/restore_from_backup.png)

Choose the newly created volume and press Restore Backup to Volume

![Status-restore-volume](/img/openstack-iaas/guides/restore_from_backup-2.png)

### Automatically create a new volume and restore a backup to that volume
Navigate to ["Project" → "Volumes" → "Backups"](https://ops.elastx.cloud/project/backups/) and press Restore Backup.

![Status-restore-volume](/img/openstack-iaas/guides/restore_from_backup.png)

Select Create a New Volume and press Restore Backup to Volume.

![Status-restore-volume](/img/openstack-iaas/guides/restore_from_backup-3.png)

The restored backup will be available in ["Project" → "Volumes"](https://ops.elastx.cloud/project/volumes/)

![Status-restore-volume](/img/openstack-iaas/guides/restore_from_backup-4.png)

## Volume Backup using CLI

List all available volumes:
```bash
openstack volume list
+--------------------------------------+--------------------------------------+--------+------+-------------------------------------+
| ID                                   | Name                                 | Status | Size | Attached to                         |
+--------------------------------------+--------------------------------------+--------+------+-------------------------------------+
| 3af38568-20fc-4c36-bca4-72555a6761e4 | 3af38568-20fc-4c36-bca4-72555a6761e4 | in-use |   20 | Attached to MyInstance on /dev/vda  |
+--------------------------------------+--------------------------------------+--------+------+-------------------------------------+
```

Create backup of your volume with ```openstack volume backup create <Volume ID or Name> --description <description of your volume> ``` 
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
<!---
Check backup creation status:
```bash
openstack volume backup list
+--------------------------------------+----------------+---------------------+----------+------+
| ID                                   | Name           | Description         | Status   | Size |
+--------------------------------------+----------------+---------------------+----------+------+
| 1c06756f-ebe1-4efd-a419-e94184f86fe8 | MyVolumeBackup | backup_of_my_volume | creating |   20 |
+--------------------------------------+----------------+---------------------+----------+------+
```
--->

When the creation is finnished the backup status will show as ```available```:
```bash
openstack volume backup list
+--------------------------------------+----------------+---------------------+-----------+------+-------------------+--------------------------------------+---------------+
| ID                                   | Name           | Description         | Status    | Size | Availability Zone | Volume                               | Container     |
+--------------------------------------+----------------+---------------------+-----------+------+-------------------+--------------------------------------+---------------+
| 1c06756f-ebe1-4efd-a419-e94184f86fe8 | MyVolumeBackup | backup_of_my_volume | available |   20 | sto1              | 3af38568-20fc-4c36-bca4-72555a6761e4 | volumebackups |
+--------------------------------------+----------------+---------------------+-----------+------+-------------------+--------------------------------------+---------------+
```

Create a new volume to restore to from backup
> **Beware:** Volume Size has to be at minimum the size of the backup.
The Volume also has to be in the same Availability-zone as the instance it will be attached too.

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
Restore backup to the newly created volume

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

After the backup is restored, it will show as available:

```bash
openstack volume list --long
+--------------------------------------+--------------------------------------+-----------+------+----------+----------+-------------------------------------+--------------------------------------+
| ID                                   | Name                                 | Status    | Size | Type     | Bootable | Attached to                         | Properties                           |
+--------------------------------------+--------------------------------------+-----------+------+----------+----------+-------------------------------------+--------------------------------------+
| f63a7a2d-7321-49e3-b909-d49fee733f21 | my_volume_restore                    | available |   20 | 16k-IOPS | true     |                                     |                                      |
| 3af38568-20fc-4c36-bca4-72555a6761e4 | 3af38568-20fc-4c36-bca4-72555a6761e4 | in-use    |   20 | 4k-IOPS  | true     | Attached to MyInstance on /dev/vda  | attached_mode='rw', readonly='False' |
+--------------------------------------+--------------------------------------+-----------+------+----------+----------+-------------------------------------+--------------------------------------+
```




<!---

To create a pair of application credentials run the `openstack application credential create <name>` command. By default the same access as the user running the command will be given. If you wish to override the roles given add `--role <role>` for each role you want to add.

You can also set an expiration date when creating a pair of application credentials, add the flag `--expiration` followed by a timestamp in the following format: `YYYY-mm-ddTHH:MM:SS`.

For more detail you can [visit the OpenStack documentation](https://docs.openstack.org/python-openstackclient/train/cli/command-objects/application-credentials.html) that goes more into detail on all avaible options.

An example that will give access to the most commonly used APIs:

```bash
openstack application credential create test --role _member_ --role creator --role load-balancer_member

+--------------+----------------------------------------------------------------------------------------+
| Field        | Value                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
| description  | None                                                                                   |
| expires_at   | None                                                                                   |
| id           | 3cd933bbcf824bdc9f77f37692eea60a                                                       |
| name         | test                                                                                   |
| project_id   | bb301d6172f54d749f9aa3094d77eeef                                                       |
| roles        | _member_ creator load-balancer_member                                                  |
| secret       | ibHyYuIPQCf-IKVN0qOEAgf4CNvDWmT5ltI6mdbmUTMD7OvJTu-5nXX0U6_5EOXTKriq7C7Ka06wKmJa0yLcKg |
| unrestricted | False                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
```

> **Beware:** You will not be able to view the secret again after creation. In case you forget the secret you will need to delete and create a new pair of application credentials.

### Create an openrc file

```bash
#!/usr/bin/env bash
export OS_AUTH_TYPE=v3applicationcredential
export OS_AUTH_URL=https://ops.elastx.cloud:5000/v3
export OS_APPLICATION_CREDENTIAL_ID="<ID>"
export OS_APPLICATION_CREDENTIAL_SECRET="<SECRET>"
export OS_REGION_NAME="se-sto"
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3
```

## Available roles

Below you will find a table with available roles and what they mean.

| Role name | Description |
|---|---|
| `_member_` | Gives access to nova, neutron and glance. This allowed to manage servers, networks, security groups and images (this role is currently always given) |
| `creator` | Gives access to barbican. The account can create and read secrets, this permission is also requierd when creating an encrypted volumes |
| `heat_stack_owner` | Gives access to manage heat |
| `load-balancer_member` | Gives access to create and manage existing load-balancers |
| `swiftoperator` | Gives access to object storage (all buckets) |



```
-->
