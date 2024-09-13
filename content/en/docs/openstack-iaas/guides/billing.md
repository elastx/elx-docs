---
title: "Billing"
description: "Guide on how to get billing data from OpenStack API/CLI"
weight: 1
alwaysopen: true
---

## Overview

We use *OpenStack CloudKitty* for billing purposes and with it's open API it is possible to get detailed information about the cost of resources.

!NOTE! The billing data engine is ALWAYS 4 hours behind so it is only possible to retrieve rating data up until 4 hours ago! This is to ensure that all billing data is in place before calculating costs.

## Prerequisites

To fetch data from cloudkitty using the OpenStack CLI it is neccessary to install the openstack python client and the openstack cloudkitty python client.
```pip install python-openstackclient python-cloudkittyclient```
As of this writing version 5.2.2 of the openstack client and 4.8.0 of the cloudkitty client is working well


## Known limitations

As cloudkitty stores data for a long time retrieval of data where the begin timestamp is omitted or more than 1 month ago will take a very long time or cause a timeout. Even fetching a month worth of data will take at least 10 minutes so do have patience when exploring your data with this API.


## Fetch summary for last month

To fetch the total summary for the last month:
```
$ openstack rating summary get -b $(date --date='1 month ago' -Isecond)
+----------------------------------+---------------+-------------+---------------------+---------------------+
| Tenant ID                        | Resource Type | Rate        | Begin Time          | End Time            |
+----------------------------------+---------------+-------------+---------------------+---------------------+
| 17cb6c5e5af8481e8960d8c4f4131b0f | ALL           | 47511.96316 | 2024-07-28T18:57:28 | 2024-09-01T00:00:00 |
+----------------------------------+---------------+-------------+---------------------+---------------------+
```

## Fetch dataframes for specific resource types

It is also possible to fetch data for specific resources or resource types. This is specifically usefull for getting costs for a specific resouce like an instance or volume.

-s service
-g group_by res_type tenant_id

```
$ openstack rating summary get -b $(date --date='1 day ago' -Isecond) -g res_type
+----------------------------------+--------------------------+-----------+---------------------+---------------------+
| Tenant ID                        | Resource Type            | Rate      | Begin Time          | End Time            |
+----------------------------------+--------------------------+-----------+---------------------+---------------------+
| 17cb6c5e5af8481e8960d8c4f4131b0f | network-traffic-sent     | 0         | 2024-08-27T19:59:04 | 2024-09-01T00:00:00 |
| 17cb6c5e5af8481e8960d8c4f4131b0f | network-traffic-received | 0         | 2024-08-27T19:59:04 | 2024-09-01T00:00:00 |
| 17cb6c5e5af8481e8960d8c4f4131b0f | image.size               | 0.16569   | 2024-08-27T19:59:04 | 2024-09-01T00:00:00 |
| 17cb6c5e5af8481e8960d8c4f4131b0f | snapshot.size            | 0.22      | 2024-08-27T19:59:04 | 2024-09-01T00:00:00 |
| 17cb6c5e5af8481e8960d8c4f4131b0f | storage.objects.size     | 1.43383   | 2024-08-27T19:59:04 | 2024-09-01T00:00:00 |
| 17cb6c5e5af8481e8960d8c4f4131b0f | router                   | 14.96     | 2024-08-27T19:59:04 | 2024-09-01T00:00:00 |
| 17cb6c5e5af8481e8960d8c4f4131b0f | ip.floating              | 21.12     | 2024-08-27T19:59:04 | 2024-09-01T00:00:00 |
| 17cb6c5e5af8481e8960d8c4f4131b0f | volume.size              | 686.90159 | 2024-08-27T19:59:04 | 2024-09-01T00:00:00 |
| 17cb6c5e5af8481e8960d8c4f4131b0f | instance                 | 688.09399 | 2024-08-27T19:59:04 | 2024-09-01T00:00:00 |
+----------------------------------+--------------------------+-----------+---------------------+---------------------+
```


```
$ openstack rating summary get -b $(date --date='1 day ago' -Isecond) -s instance
+----------------------------------+---------------+-----------+---------------------+---------------------+
| Tenant ID                        | Resource Type | Rate      | Begin Time          | End Time            |
+----------------------------------+---------------+-----------+---------------------+---------------------+
| 17cb6c5e5af8481e8960d8c4f4131b0f | instance      | 688.09399 | 2024-08-28T05:59:49 | 2024-09-01T00:00:00 |
+----------------------------------+---------------+-----------+---------------------+---------------------+
```


## Fetch raw dataframes

Cloudkitty is built on a concept called dataframes which is the actual data rated. Each dataframe contains the rated value for each resource for an hour interval and can be exported as a CSV which can then be used to summarize the totals per resource.

Example config for generating a CSV that contains all relevant information
```
$ cat tmp/cloudkitty.csv 
# This exact file format must be respected (- column_name: json_path)
# The path is interpreted using jsonpath-rw-ext, see
# https://github.com/sileht/python-jsonpath-rw-ext for syntax reference
- 'Begin': '$.begin'
- 'End': '$.end'
- 'Resource Type': '$.service'
- 'Resource ID': '$.desc.id'
- 'Qty': '$.volume'
- 'Cost': '$.rating'
```

Get raw dataframes for all instances in the project as a CSV for the last 5 hours. 
```
$ time openstack rating dataframes get -b $(date --date='5 hours ago' -Isecond) -r instance -f df-to-csv --format-config-file tmp/cloudkitty.csv 
Begin,End,Resource Type,Resource ID,Qty,Cost        
2024-09-10T09:00:00,2024-09-10T10:00:00,instance,064e8601-8c83-477c-85c4-f40884ad71b9,1,3.36
2024-09-10T09:00:00,2024-09-10T10:00:00,instance,21bcc6e2-416a-48c8-8684-2cfaa806e0e3,1,0.14
2024-09-10T10:00:00,2024-09-10T11:00:00,instance,064e8601-8c83-477c-85c4-f40884ad71b9,1,3.36
2024-09-10T10:00:00,2024-09-10T11:00:00,instance,21bcc6e2-416a-48c8-8684-2cfaa806e0e3,1,0.14
2024-09-10T11:00:00,2024-09-10T12:00:00,instance,064e8601-8c83-477c-85c4-f40884ad71b9,1,3.36
2024-09-10T11:00:00,2024-09-10T12:00:00,instance,21bcc6e2-416a-48c8-8684-2cfaa806e0e3,1,0.14
```

From this CSV output it is fairly easy to sum up the Cost per instance id to get the detailed cost per instance for an interval
