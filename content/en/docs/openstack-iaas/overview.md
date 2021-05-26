---
title: "Overview"
description: "Overview over ELASTX OpenStack IaaS"
weight: 1
alwaysopen: true
---

*ELASTX OpenStack IaaS* consists of a fully redundant installation spread over three different physical locations (openstack availability zones) in Stockholm, Sweden. Managed and monitored by us 24x7. You also have access to our support at any time.

The current setup is based on the OpenStack version Queens.

![Overview of OpenStack IaaS data centers](/img/dc-1.png)

## Services

Our OpenStack environment currently runs the following services:

- Keystone - Authentication service
- Nova - Compute service
- Neutron - Network service
- Heat - Orchestration service
- Horizon - Dashboard
- Glance - Image store. We provide images for the most popular operating systems. All Linux images except CentOS are unmodified from the official vendor cloud image. For CentOS we have changed out xfs file system to ext4 for stability reasons. You can find source code for our CentOS build process [here](https://github.com/elastx/centos-cloudimg).
- Barbican - Secret store service which is powered by physical HSM appliances by Fortanix [HSM and KMS solution for OpenStack](https://elastx.se/en/blog/check-out-our-customer-testimonial-for-fortanix-services)
- Octavia - Load balancer service, barbican integration for SSL termination
- Cinder - Block storage with SSD based block storage and guaranteed IOPS reservations which is integrated with Barbican for optional encrypted volumes.
- Swift - Object storage
- Ceilometer - Metric storage, stores key metrics for the services like cpu and memory utilization
- CloudKitty - Rating service

## Differencies and limitations
As every OpenStack cloud has it's own unique set of features and underlying infrastructure, there are some things that might differentiate in our cluster from others. Down below is a list of what we believe is good to know when working in our OpenStack cloud.

### Compute
- Live migration is not supported.
- An instance with volumes attached cannot be migrated to another Availability Zone.
- Machines booting from ephemeral storage cannot use an image larger than 64GiB, especially important if booting from snapshot.

### Dashboard
- Objects in Object store cannot be listed in Horizon once an account has >1000 buckets or >10000 objects in it.

### Load Balancing
- It's not possible to limit access to a Load Balancer instance with a Floating IP attached to it.
- A Load Balancer cannot be referenced by ID as a source in a Security Group.

### Network
- Maximum of one router per project. We only support a single router due to how resources are allocated in our network infrastructure.
- An instance cannot connect to its own Floating IP. Best practice is to use internal IP when communicating internally (e.g. clustering).
- The network `elx-public1` is provided by the platform and cannot be removed from a project. You can attach an interface on your router on this network for internet access. This is also used as a pool for requesting Floating IP addresses.

### Object store
- To upload objects larger than 5GiB, use of DLO/SLO is necessary to split the object in multiple smaller parts. See [https://docs.openstack.org/swift/latest/overview_large_objects.html](https://docs.openstack.org/swift/latest/overview_large_objects.html).
- python-swiftclient is not correctly adding headers to segmented files which cause fragments to remain when using 'X-Delete-After' header to automatically delete objects after a certain time has passed. This isn't unique to our cloud but we feel that it's important to know. See [https://bugs.launchpad.net/python-swiftclient/+bug/1159951](https://bugs.launchpad.net/python-swiftclient/+bug/1159951).

### Secrets
- Secrets can only be deleted by the user that created them.

### Storage
- Volumes cannot be attached nor migrated across Availability Zones.
- Encrypted volumes can only be deleted by the user that created them.
- It's not supported to snapshot the ephemeral volume of dedicated instances (flavour with dedicated in name).
- Encrypted volumes need to be detached and attached manually for instances to discover the new volume size when resizing.
