---
title: "Changelog for OpenStack Train"
description: "Upgrade of version Queens to Train"
alwaysopen: true
---

## Changelog overview
The purpose of this upgrade is to take the OpenStack platform from the current “Queens” release to the “Train” release. This will include an intermediate upgrade to the “Rocky” release. The “Stein” release is skipped because it isn’t required.
* No public APIs are deprecated by these upgrades
* Support for TLS version 1.1 will be dropped during the upgrade to the “Train” release

## Deprecations and dropped support
### APIs
None of the public OpenStack APIs will be deprecated by the planned upgrades.

### TLS
Support for TLS version 1.1 will be dropped during the upgrade to the "Train” release. This will cause issues for API clients only supporting TLS version 1.1 or below as connections will be rejected. Upgrade and check client configuration before the upgrades!

### Horizon (Web UI)
You will no longer be able to download “OpenStack RC File v2” by clicking your username in the top right corner. Only “OpenStack RC File v3” will be available.

## Visible changes (Horizon/web UI)
* The “Overview” page will be divided into categories by resource type. It will also contain information about more resources.
* “Server Groups” are now visible under the “Compute” heading.
* “Consistency Groups” and “Consistency Groups Snapshots” have been replaced by “Groups” and “Group Snapshots” under the “Volume” heading.
* It is now possible to manage “Application Credentials” under the “Identity” heading.

## New features
The upgrades come with a lot of new features, such as:
* UDP load balancers in Octavia (Train)
* [Fine grained access rules](https://docs.openstack.org/api-ref/identity/v3/#application-credentials "Application Credentials") can now be defined for “Application Credentials” (Train)

### Reference
To get the complete picture you may refer to the release notes found [here](https://docs.openstack.org/releasenotes/ "OpenStack Relese Notes") for the following projects:
* barbican: [rocky](https://docs.openstack.org/releasenotes/barbican/rocky.html), [stein](https://docs.openstack.org/releasenotes/barbican/stein.html), [train](https://docs.openstack.org/releasenotes/barbican/train.html)
* cinder: [rocky](https://docs.openstack.org/releasenotes/cinder/rocky.html), [stein](https://docs.openstack.org/releasenotes/cinder/stein.html), [train](https://docs.openstack.org/releasenotes/cinder/train.html)
* glance: [rocky](https://docs.openstack.org/releasenotes/glance/rocky.html), [stein](https://docs.openstack.org/releasenotes/glance/stein.html), [train](https://docs.openstack.org/releasenotes/glance/train.html)
* heat: [rocky](https://docs.openstack.org/releasenotes/heat/rocky.html), [stein](https://docs.openstack.org/releasenotes/heat/stein.html), [train](https://docs.openstack.org/releasenotes/heat/train.html)
* horizon: [rocky](https://docs.openstack.org/releasenotes/horizon/rocky.html), [stein](https://docs.openstack.org/releasenotes/horizon/stein.html), [train](https://docs.openstack.org/releasenotes/horizon/train.html)
* keystone: [rocky](https://docs.openstack.org/releasenotes/keystone/rocky.html), [stein](https://docs.openstack.org/releasenotes/keystone/stein.html), [train](https://docs.openstack.org/releasenotes/keystone/train.html)
* neutron: [rocky](https://docs.openstack.org/releasenotes/neutron/rocky.html), [stein](https://docs.openstack.org/releasenotes/neutron/stein.html), [train](https://docs.openstack.org/releasenotes/neutron/train.html)
* nova: [rocky](https://docs.openstack.org/releasenotes/nova/rocky.html), [stein](https://docs.openstack.org/releasenotes/nova/stein.html), [train](https://docs.openstack.org/releasenotes/nova/train.html)
* octavia: [rocky](https://docs.openstack.org/releasenotes/octavia/rocky.html), [stein](https://docs.openstack.org/releasenotes/octavia/stein.html), [train](https://docs.openstack.org/releasenotes/octavia/train.html)
* swift: [rocky](https://docs.openstack.org/releasenotes/swift/rocky.html), [stein](https://docs.openstack.org/releasenotes/swift/stein.html), [train](https://docs.openstack.org/releasenotes/swift/train.html)