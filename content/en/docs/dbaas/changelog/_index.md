---
title: "Changelog"
description: "Latest changes for ELASTX DBaaS"
weight: 2
alwaysopen: true
---

# V 1.48
## Overview
In this release we introduce MSSQL, the new Openstack V2 instance flavors and volume types giving even better performance and price efficiency.

## New features
The upgrades come with a bunch of new features, such as:
* MSSQL in Standalone and Always On versions
* Lifecycle management, database upgrades
* Improved automatic datastore failover handling
* Change existing storage volume type and size
* Account password management
* Choose new V2 node flavors with improved performance
* Mobile UI
* Datastore overview page paging and filtering
* Implement date picking for DBgrowth
* Terraform provider upgrade allowing automated datastore and firewall management
  
 ## Important fixes 
* Fixed a problem where DNS name for datatore nodes occasionally disappeared.

# V 1.47
## Overview
Focus on automated failure handling.

## New features
* Automated failure handling
* Datastore creation from previous backup
* Database growth
* Expose monitoring ports for customer prometheus
* Repair and node scaling for MSSQL

## Improvement
- navigational bar: icons
- Upgrade datastore - tool tip with help text
- CCX UI: Filter list of datastores on database type and tags.
- API for grouped firewall rules


# V 1.46
## Overview
This upgrade introduces improved life cycle management and initial backend support for MSSQL Server 2022. 
* UI improvements navigational bar.
* Upgrade datastore.
* CCX UI: Filter list of datastores.
* API for grouped firewall rules
