---
title: "Changelog for OpenStack Ussuri"
description: "Changes  Openstack from Train to Ussuri"
alwaysopen: true
---

## Changelog overview
The purpose of this upgrade is to take the OpenStack platform from the current Train release to the Ussuri release. 
* No public APIs deprecations
* API endpoints are now available over IPv6 (note that IPv6 for compute and loadbalancers is still unsupported)

## Deprecations and dropped support
### APIs
None of the public OpenStack APIs will be deprecated by the planned upgrades.

## New features
The upgrades come with a lot of new features, such as:
* API endpoints are now available over IPv6
* Barbican secrets can now be removed by other users with the Secret Store permission (previously only the creator of the secret could remove it). 

### Reference
The complete list of changelogs can be found [here](https://docs.openstack.org/releasenotes/), and the changelogs for the major projects we use can be seen below.  
Please note that not all of the changes may be relevant to our platform.  
* [barbican](https://docs.openstack.org/releasenotes/barbican/ussuri.html)
* [cinder](https://docs.openstack.org/releasenotes/cinder/ussuri.html)
* [glance](https://docs.openstack.org/releasenotes/glance/ussuri.html)
* [heat](https://docs.openstack.org/releasenotes/heat/ussuri.html)
* [horizon](https://docs.openstack.org/releasenotes/horizon/ussuri.html)
* [keystone](https://docs.openstack.org/releasenotes/keystone/ussuri.html)
* [neutron](https://docs.openstack.org/releasenotes/neutron/ussuri.html)
* [nova](https://docs.openstack.org/releasenotes/nova/ussuri.html)
* [octavia](https://docs.openstack.org/releasenotes/octavia/ussuri.html)
* [swift](https://docs.openstack.org/releasenotes/swift/ussuri.html)