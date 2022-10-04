---
title: "Flavor Migration"
description: "Guide to change flavor"
weight: 1
alwaysopen: true
---

## Overview

This guide will help you getting started with changing Flavor in OpenStack's Horizon and CLI.<br/>
Get more information about the [OpenStack command-line client](https://docs.openstack.org/python-openstackclient/train/).

## Changing flavor using Openstack Horizon

First, choose the instance you want to change.

![Choose-instance](/img/openstack-iaas/guides/ops_flavor-migration-1.png)

In the actions menu, pick resize instance.
> **Beware:** The instance will go down immediately!

![Choose-instance](/img/openstack-iaas/guides/ops_flavor-migration-2.png)

Pick your new flavor of your choice.
> **Info:** If you have an ephemeral-disk, you have to choose the same disk size as the older flavor or larger.

![Choose-instance](/img/openstack-iaas/guides/ops_flavor-migration-3.png)

Confirm the changes

![Choose-instance](/img/openstack-iaas/guides/ops_flavor-migration-4.png)





## Changing flavor using OpenStack CLI


### Changing flavor of an instance using Resize.
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

> **Info:** If you have an ephemeral-disk, you have to choose the same disk size as the older flavor or larger.
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


