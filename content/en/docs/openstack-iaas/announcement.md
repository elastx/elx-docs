---
title: "Announcements"
description: "Announcement for the OpenStack cloud"
weight: 1
alwaysopen: true
---

## 2022-01-17


We are happy to announce that all volumes in OpenStack are now encrypted at no additional cost and we will soon start the upgrade of the OpenStack version with new features and improvements. 

### Encrypted Volumes
Our goal is to provide the best conditions and tools to run applications in a secure and predictable way. During 2021 we enabled encryption at rest for all volumes in our Openstack IaaS. Prior to this change you could select encryption as an option which cost more than non encrypted volumes. Now all new and existing volumes are encrypted at no additional cost.
The option to select encrypted volumes is now obsolete and will be removed shortly.

The following volume types are deprecated and will be disabled 2022-09-30.<br />
4k-IOPS-enc<br />
8k-IOPS-enc<br />
16k-IOPS-enc<br />


If you are running any of the above volume types you need to migrate the data to other volume types.<br />

When you migrate the legacy encrypted volumes to our standard volumes you will reduce the cost for your volumes. You can’t change the volume type from a legacy encrypted to a standard volume, you need to create a new volume and migrate the data.
Please contact support if you need any help or recommendation on how to do this.

### OpenStack IaaS upgrade
We will soon upgrade our OpenStack platform and this will be performed in three steps.
The plan is to start the upgrade in February. We will announce service windows for the upgrade on our status page, https://status.elastx.se. Here you can also subscribe to get notifications about service windows and incidents.

##### Step 1
OpenStack version will be upgraded to Rocky.
There will be disturbance with the OpenStack API but we do not expect any disturbance on running workloads.

##### Step 2
Upgrade operating system on control plane and compute nodes.<br />
<span style="color:red">There will be disruption of workloads during the upgrade</span>. We will upgrade one availability zone at a time.

##### Step 3
OpenStack version will be upgraded to Train.
There will be disturbance with the OpenStack API but we do not expect any disturbance on running workloads.
