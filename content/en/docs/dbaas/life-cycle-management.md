---
title: "Life-cycle Management and Upgrades"
description: "Keeping your datastores up to date"
weight: 2
alwaysopen: true
---

## Overview
Elastx DBaaS will keep your system updated with the latest security patches for both the operating system and the database software.

You will be informed when there is a pending update and you have two options:
- Apply the update now
- Schedule a time for the update

The update will be performed using a roll-forward upgrade algorithm:
1. The oldest replica (or primary if no replica exist) will be selected first
2. A new node will be added with the same specification as the oldest node and join the datastore
3. The oldest node will be removed
4. 1-3 continues until all replicas are updated.
5. Lastly the primary will be updated. A new node will be added, the new node will be promoted to become the new primary, and the old primary will be removed.

> Please be aware that the floating ip addresses assigned to the nodes may change. It is recommended to use the external DNS name found in the Overview tab of the UI instead.

## Upgrade now
This option will start the upgrade now.

## Scheduled upgrade
The upgrade will start at a time (in UTC) and on a weekday which suits the application.
Please note, that for primary-replica configurations, the update will cause the current primary to be changed.

