---
title: "Flavor Migration"
description: "Guide to change flavor"
weight: 1
alwaysopen: true
---

## Overview

This guide will help you getting started with changing Flavor in OpenStack's Horizon and CLI.<br/>
Get more information about the [OpenStack command-line client](https://docs.openstack.org/python-openstackclient/train/).

## Changing flavor using OpenStack CLI

### Changing flavor of an instance with a bootable volume

#### Create a snapshot of the image

List all available instances: ```openstack server list```.
```bash
openstack server list
+--------------------------------------+------------+---------+--------------------------+----------------------------+---------------+
| ID                                   | Name       | Status  | Networks                 | Image                      | Flavor        |
+--------------------------------------+------------+---------+--------------------------+----------------------------+---------------+
| ad56b0e9-788b-4f98-8bf0-73f4c8862350 | myinstance | ACTIVE  | test-network=192.168.1.2 |                            | v1-small-1    |
+--------------------------------------+------------+---------+--------------------------+----------------------------+---------------+
```

Show information about the instance which you want to change flavor: ```openstack <Instance ID or Name>```.  
From the excerpt below we can see that the flavor being used is "v1-small-1" and there's a volume attached to the instance.
```bash
openstack server show myinstance
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | AUTO                                                     |
| OS-EXT-AZ:availability_zone | sto1                                                     |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2022-07-27T08:26:21.000000                               |
| addresses                   | test-network=192.168.1.2                                 |
| created                     | 2022-07-27T08:26:02Z                                     |
| flavor                      | v1-small-1 (83d8b44a-26a0-4f02-a981-079446926445)        |
| name                        | myinstance                                               |
| status                      | ACTIVE                                                   |
| updated                     | 2022-07-27T08:26:21Z                                     |
| volumes_attached            | id='2512915e-775d-4c03-bd3a-c86a9cc3c5f7'                |
+-----------------------------+----------------------------------------------------------+
```

Create an image snapshot of the instance: ```openstack server image create --name <Snapshot Name> <Instance ID or Name>``` 
```bash
openstack server image create --name my_snapshot myinstance
```

Check to see if the snapshot-image is created and active: ```openstack image list --name <Name of Snapshot>```
```bash
openstack image list --name my_snapshot
+--------------------------------------+-------------+--------+
| ID                                   | Name        | Status |
+--------------------------------------+-------------+--------+
| 672bde6e-a798-4d41-8064-f38ce85e31df | my_snapshot | active |
+--------------------------------------+-------------+--------+
```

#### Create new instance with a different flavor from your snapshot

List all available flavors: 
```bash
openstack flavor list
```

Create a new instance from your snapshot: ```openstack server create <Name of Instance> --flavor <Flavor ID or Name> --image <Snapshot ID or Name> --availability-zone <sto1/sto2/sto3> <args>```  
The example below uses flavor "v1-standard-2"
> **Beware:** The new instance has to be in the same availability-zone as the original instance.
```bash
openstack server create newinstance --flavor v1-standard-2 --image my_snapshot --availability-zone sto1 --network test-network --security-group my-sg --key-name mykey
+-----------------------------+------------------------------------------------------+
| Field                       | Value                                                |
+-----------------------------+------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                               |
| OS-EXT-AZ:availability_zone | sto1                                                 |
| OS-EXT-STS:power_state      | NOSTATE                                              |
| OS-EXT-STS:task_state       | scheduling                                           |
| OS-EXT-STS:vm_state         | building                                             |
| created                     | 2022-07-27T08:38:07Z                                 |
| flavor                      | v1-standard-2 (3f73fc93-ec61-4808-88df-2580d94c1a9b) |
| image                       | my_snapshot (672bde6e-a798-4d41-8064-f38ce85e31df)   |
| name                        | newinstance                                          |
| security_groups             | name='f0ef7834-6d80-4124-ba52-cad4cca1435b'          |
| status                      | BUILD                                                |
| updated                     | 2022-07-27T08:38:07Z                                 |
| volumes_attached            |                                                      |
+-----------------------------+------------------------------------------------------+
```

List all available instances again and check if the new instance has the new flavor: ```openstack server list```
```bash
openstack server list
+--------------------------------------+-------------+---------+-----------------------------------------+----------------------------+---------------+
| ID                                   | Name        | Status  | Networks                                | Image                      | Flavor        |
+--------------------------------------+-------------+---------+-----------------------------------------+----------------------------+---------------+
| dfac4a33-42f3-4d39-b435-9ffd0c6c442c | newinstance | ACTIVE  | test-network=192.168.1.22               | my_snapshot                | v1-standard-2 |
| ad56b0e9-788b-4f98-8bf0-73f4c8862350 | myinstance  | ACTIVE  | test-network=192.168.1.2                |                            | v1-small-1    |
+--------------------------------------+-------------+---------+-----------------------------------------+----------------------------+---------------+
```
Show more information about the new instance: ```openstack <Instance ID or Name>```.
```bash
openstack server show newinstance
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | sto1                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2022-07-27T08:38:26.000000                               |
| addresses                   | test-network=192.168.1.22                                |
| created                     | 2022-07-27T08:38:07Z                                     |
| flavor                      | v1-standard-2 (3f73fc93-ec61-4808-88df-2580d94c1a9b)     |
| image                       | my_snapshot (672bde6e-a798-4d41-8064-f38ce85e31df)       |
| name                        | newinstance                                              |
| status                      | ACTIVE                                                   |
| updated                     | 2022-07-27T08:38:26Z                                     |
| volumes_attached            | id='1c12256a-151d-4e5d-a4a9-11b8f50d6a20'                |
+-----------------------------+----------------------------------------------------------+
```

### Changing flavor of an instance with an ephemeral storage using Resize.
> **Beware:** It's highly recommended to create a backup before resizing an instance. This will also cause some downtime during the migration.

List all available instances: ```openstack server list```.
```bash
openstack server list
+--------------------------------------+-------------+---------+------------------------------------------+----------------------------+---------------+
| ID                                   | Name        | Status  | Networks                                 | Image                      | Flavor        |
+--------------------------------------+-------------+---------+------------------------------------------+----------------------------+---------------+
| f858e3ba-74e8-4e9a-9b59-7bf5c90cf58d | Instance    | ACTIVE  | test-network=192.168.1.11                | cirros-0.5.1               | v1-small-1    |
+--------------------------------------+-------------+---------+------------------------------------------+----------------------------+---------------+
```

Show information about the instance you want to change flavor: ```openstack server show <Instance ID or Name>```  
From the excerpt below we can see that the flavor being used is "v1-small-1" and there's no volume attached to the instance.
```bash
openstack server show Instance
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | AUTO                                                     |
| OS-EXT-AZ:availability_zone | sto1                                                     |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2022-07-27T08:57:35.000000                               |
| addresses                   | test-network=192.168.1.11  				                 |
| created                     | 2022-07-27T08:57:21Z                                     |
| flavor                      | v1-small-1 (83d8b44a-26a0-4f02-a981-079446926445)        |
| image                       | cirros-0.5.1 (1525aeac-1a8e-4696-b715-f8f9ffa8f0b9)      |
| name                        | Instance                                                 |
| status                      | ACTIVE                                                   |
| updated                     | 2022-07-27T08:57:35Z                                     |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
```

List all available flavors: 
```bash
openstack flavor list
```

Change flavor with the resize option: ```openstack server resize --flavor <Flavor ID or Name> <Instance ID or Name>```
> **Beware:** The instance will go down immediately after entering this command!
```bash
openstack server resize --flavor v1-standard-2 Instance
```

To finalize the flavor migration you have to confirm the resizing.  
List all instances again and it will show "VERIFY_RESIZE" under status:
```bash
openstack server list
+--------------------------------------+-------------+---------------+------------------------------------------+----------------------------+---------------+
| ID                                   | Name        | Status        | Networks                                 | Image                      | Flavor        |
+--------------------------------------+-------------+---------------+------------------------------------------+----------------------------+---------------+
| f858e3ba-74e8-4e9a-9b59-7bf5c90cf58d | Instance    | VERIFY_RESIZE | test-network=192.168.1.11, 91.197.43.171 | cirros-0.5.1               | v1-standard-2 |
+--------------------------------------+-------------+---------------+------------------------------------------+----------------------------+---------------+
```

To confirm the resize, enter: ```openstack server resize confirm <Instance ID or Name>```
```bash
openstack server resize confirm Instance
```

To revert the resize, enter: ```openstack server resize revert <Instance ID or Name>```

After confirming the changes check the status again with ```openstack server list```.  
It should now show the new flavor and the status should be active.
```bash
openstack server list
+--------------------------------------+-------------+---------+------------------------------------------+----------------------------+---------------+
| ID                                   | Name        | Status  | Networks                                 | Image                      | Flavor        |
+--------------------------------------+-------------+---------+------------------------------------------+----------------------------+---------------+
| f858e3ba-74e8-4e9a-9b59-7bf5c90cf58d | Instance    | ACTIVE  | test-network=192.168.1.11				  | cirros-0.5.1               | v1-standard-2 |
+--------------------------------------+-------------+---------+------------------------------------------+----------------------------+---------------+


