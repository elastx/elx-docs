---
title: "Changelog"
description: "Latest changes for ELASTX DBaaS"
weight: 2
alwaysopen: true
---

# V 1.48
## Overview
In this release we introduce MSSQL, the new Openstack V2 instance flavors and volume types giving even better performance and price efficiency.

## Changes
* MSSQL in Standalone and Always On versions.
* Lifecycle management, database upgrades.
* Improved automatic datastore failover handling.
* Change existing datastore volume type and size.
* Account password management.
* Choose new V2 node flavors with improved performance.
* Mobile UI.
* Datastore UI overview page paging and filtering.
* Terraform provider upgrade allowing automated datastore and firewall management.
* Improved documentation with more practical examples for, among other, external backup/restore and Terraform provider usage, and much more.
  
## Important fixes 
* Fixed a problem where DNS name for datatore nodes occasionally disappeared.
* Fixed Postgres creation and restore who occasionally could fail.
* Corrected a problem where datastore creation from backup failed.


# V 1.47
## Overview
The release focus on datastore failure handling, e.g. when nodes are lost and how the failover is managed. It introduces improved general database life cycle management and initial backend support for MSSQL Server 2022.

## Changes
* Automatatic datastore failure handling.
* Datastore creation from backups.
* Improved datastore upgrade process.
* Expose monitoring ports for customer prometheus clients.
* Repair and node scaling for MSSQL.
* UI view filtering and list presentation.
* Improved UI guidance tool tips.
* Terraform API for grouped firewall rules.

## Important fixes
* Corrected a problem where promotion of new MSSQL primary led to endless loops.
* Fixed problem where DNS records for datastore nodes could sometime disappear after upgrades.
* Corrected a problem with inconsistent logging and presentation of changed cluster and node status.
  

# V 1.46
## Overview
This release introduces configuration management and simplified service access. Initial support for life cycle management is introduced.

## Changes
* Access to services/failover. This provides the user with a single entrypoint to the datastore.
* Configuration Management. Ability to let the end-user tune certain configuration values.
* Lifecycle Management. Ability to upgrade datastores (OS and database software) using a roll-forward upgrade method.
* Improved customer error interaction for handling nodes.

## Important fixes
* Corrected a bug that caused the control plane process to restart occasionally.