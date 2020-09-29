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

* Keystone - Authentication service
* Nova - Compute service
* Neutron - Network service
* Heat - Orchestration service
* Horizon - Dashboard
* Glance - Image store. We provide images for the most popular operating systems. All Linux images except CentOS are unmodified from the official vendor cloud image. For CentOS we have changed out xfs file system to ext4 for stability reasons. You can find source code for our CentOS build process [here](https://github.com/elastx/centos-cloudimg).
* Barbican - Secret store service which is powered by physical HSM appliances by Fortanix [HSM and KMS solution for OpenStack](https://elastx.se/en/blog/check-out-our-customer-testimonial-for-fortanix-services)
* Octavia - Load balancer service, barbican integration for SSL termination
* Cinder - Block storage with SSD based block storage and guaranteed IOPS reservations which is integrated with Barbican for optional encrypted volumes.
* Swift - Object storage
* Ceilometer - Metric storage, stores key metrics for the services like cpu and memory utilization
* CloudKitty - Rating service
