---
title: "Volume migration"
description: "Migrate volume data between Availability Zones"
weight: 1
alwaysopen: true
---

## Overview

To migrate volume data between Availability Zones (sto1|sto2|sto3) you can use Openstacks backup functionality. This backup process uses our Swift object storage, which is available across all Availability Zones.

1. Shutdown the instance whose volume will change Availability Zone. Let's say it's in sto1 now.
2. Take a backup of the volume (this may take some time, depending on the size of the volume). 
3. Create a new volume in Availability Zone sto2 and select the backup as the source. 
4. Create a new instance in Availability Zone sto2 and attach the newly created volume.

To get a more in-depth look at how to perform backup and restore of a volume, follow our [Volume Backup & Restore](../volume_backup#overview) guide.
