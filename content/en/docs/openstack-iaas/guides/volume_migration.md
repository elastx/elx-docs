---
title: "Volume migration"
description: "Guide to migrate volume"
weight: 1
alwaysopen: true
---

## Overview

To migrate data between Availability Zones (sto1|sto2|sto3) you can use Openstacks backup function.

1. Shutdown the instance whose volume will change Availability Zone. Let's say it's in sto1 now.
2. Take a backup of the volume. 
3. Create a new volume in Availability Zone sto2 and select the backup as the source (it can be read globally). 
4. Create a new instance in Availability Zone sto2 and attach the newly created volume.
