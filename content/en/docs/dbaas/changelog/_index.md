---
title: "Changelog"
description: "Latest changes for ELASTX DBaaS"
weight: 2
alwaysopen: true
---

# V 1.51
## Overview
A new way to group custom database parameters is introduced. This allows to apply the group to multiple datastores in a more structured way. Autoscaling of volumes has been improved where the actual scaling is less intrusive than it was in 1.50. Added a SUPERUSER checkbox when creating a new PostgreSQL user, with caution prompts.

## Changes
* Parameter Groups for Database Management.
* Database Logs in Events Viewer.
* Create Datastore from incremental backup from different storage types.
* Reboot database node.
* Make Postgres SUPERUSER configurable.
   

## Important fixes
Reset password is not working
* Fixed a 401 issue when attempting to reset passwords via email links.
* Deployments stuck in deploying status forever
* Corrected state transitions so a failed deployment eventually marks as “failed” instead of hanging.
* Reduced unnecessary Service updates, lowering API calls to Kubernetes.
* Set correct interval to 15/30/60 minutes for incremental backups.
* Disabled volume-editing for ephemeral storage as it was never intended.


# V 1.50
## Overview
This release offers upward volume autoscaling, new customer database parameters, improved monitoring in terms of mail notifications and more metrics. It is now possible to create (m)TLS-based sessions where the client can prefetch server certificates. The backup management has been improved disalloving concurrent backup race conditions.

## Changes
* Auto-scale volumes, enabled by default.
* Send email notifications to end user.
* (m)TLS for Mysql/MariaDB, Postgres and Redis.
* Do all DNS queries through ExternalDNS.
* The Terraform provider has been substantially improved.

## Important fixes 
* Fixed a problem where multiple concurrent backups were executed.
* There was a problem in removing datastores stuck in creation or modifying state.
* Redis and MSSQL backup restore was not working properly.
* Optimized failover time for Always on.


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
