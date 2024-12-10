---
title: "Observability"
description: "Monitor DBaaS datastore metrics via either UI or remotely"
weight: 1
alwaysopen: true
---

## Overview
DBaaS offers metrics monitoring via the UI and remote.

Via UI there are various metrics for both databases and the nodes are presented under the datastore Monitor tab. 

Remotely it is possible to monitor by using Prometheus and different exporters. The monitoring data is exposed though the exports from each node in the datastore. This is controlled under the Firewall tab in the DBaaS UI.

The ports available for the specific datastore configuration can be seen in UI under Firewall tab and the specific IP-address entry (fold the arrow to the left of the IP-address).

---

## Exporter ports
Each exporter has its own port used by prometheus to scrape metrics.

|**Exporter**|**TCP port**|
|---|---|
|Node|9100|
|Mysql|9104|
|Postgres|9187|
|Redis|9121|
|MSSQL|9399|
  
---

## Sample visible metrics
The following tables are excerpts of metrics for the different exporters to quickly get started.

### **System** - Hardware level metrics
|**Statistic**|**Description**| 
|---|---|
|Load Average|The overall load on your Datastore within the preset period| 
|CPU Usage|The breakdown of CPU utilisation for your Datastore, including both `System` and `User` processes| 
|RAM Usage|The amount of RAM (in Gigabytes) used and available within the preset period| 
|Network Usage|The amount of data (in Kilobits or Megabits per second) received and sent within the preset period| 
|Disk Usage|The total amount of storage used (in Gigabytes) and what is available within the preset period| 
|Disk IO|The input and output utilisation for your disk within the preset period| 
|Disk IOPS|The number of read and write operations within the preset period| 
|Disk Throughput|The amount of data (in Megabytes per second) that is being read from, or written to, the disk within the preset period|

### **MySQL / MariaDB**
[MySQL metrics reference](https://dev.mysql.com/doc/mysql-em-plugin/en/myoem-metrics.html)
  - Handler Stats
    |**Statistic**|**Description**|
    |---|---|
    |Read Rnd|Count of requests to read a row based on a fixed position|
    |Read Rnd Next|Count of requests to read a subsequent row in a data file|
    |Read Next|Count of requests to read the next row in key order|
    |Read Last|Count of requests to read the last key in an index|
    |Read Prev|Count of requests to read the previous row in key order|
    |Read First|Count of requests to read a row based on an index key value|
    |Read Key|Count of requests to read the last key in an index|
    |Update|Count of requests to update a row|
    |Write|Count of requests to insert to a table|
  - Database Connections
    |**Metric**|**Description**|
    |---|---|
    |Thread Connected|Count of clients connected to the database|
    |Max Connections|Count of max connections allowed to the database|
    |Max Used Connections|Maximum number of connections in use|
    |Aborted Clients|Number of connections aborted due to client not closing|
    |Aborted Connects|Number of failed connection attempts|
    |Connections|Number of connection attempts|
  - Queries
    - Count of queries executed
  - Scan Operations
    - Count of operations for the operations: SELECT, UPDATE and DELETE
  - Table Locking
    |**Metric**|**Description**|
    |---|---|
    |Table locks immediate|Count of table locks that could be granted immediately|
    |Table locks waited|Count of locks that had to be waited due to existing locks or another reason| 
  - Temporary Tables
    |**Metric**|**Description**|
    |---|---|
    |Temporary tables|Count of temporary tables created|
    |Temporary tables on Disk|Count of temporary tables created on disk rather than in memory|
  - Aborted Connections
    |**Metric**|**Description**|
    |---|---|
    |Aborted Clients|Number of connections aborted due to client not closing|
    |Aborted Connects|Number of failed connection attempts|
    |Access Denied Errors|Count of unsuccessful authentication attempts|
  - Memory Utilisation
    |**Metric**|**Description**|
    |---|---|
    |SELECT (fetched)|Count of rows fetched by queries to the database|
    |SELECT (returned)|Count of rows returned by queries to the database|
    |INSERT|Count of rows inserted to the database|
    |UPDATE|Count of rows updated in the database|
    |DELETE|Count of rows deleted in the database|
    |Active Sessions|Count of currently running queries|
    |Idle Sessions|Count of connections to the database that are not currently in use|
    |Idle Sessions in transaction|Count of connections that have begun a transaction but not yet completed while not actively doing work|
    |Idle Sessions in transaction (aborted)|Count of connections that have begun a transaction but did not complete and were forcefully aborted before they could complete|
    |Lock tables|Active locks on the database|
    |Checkpoints requested and timed|Count of checkpoints requested and scheduled|
    |Checkpoint sync time|Time synchronising checkpoint files to disk|
    |Checkpoint write time|Time to write checkpoints to disk|

### **Redis**
[Redis metrics reference](https://docs.redis.com/latest/rs/clusters/monitoring/prometheus-metrics-definitions/)
|**Metric**|**Description**|
|---|---|
|Blocked Clients|Clients blocked while waiting on a command to execute|
|Memory Used|Amount of memory used by Redis (in bytes)|
|Connected Clients|Count of clients connected to Redis|
|Redis commands per second|Count of commands processed per second|
|Total keys|The total count of all keys stored by Redis|
|Replica Lag|The lag (in seconds) between the primary and the replica(s)|
