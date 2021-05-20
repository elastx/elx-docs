---
title: "EC2 Credentials"
description: "How to use EC2 Credentials"
weight: 1
alwaysopen: true
---

## Overview

For using the OpenStack S3 API:s you need to generate an additional set of credentials. These can then be used to store data in the Swift Object store for applications that don't have native Swift support but do support the S3 interfaces.

*NOTE: If the application does support Swift natively, this will provide superior performance and generally a better experience.*

## Create and fetch credentials using openstack cli

Make sure you have installed the openstack python client.

Generate credentials:

```shell
$ openstack ec2 credentials create
+-----------------+-----------------------------------------------------------------------------------------------------------------------------------------+
| Field           | Value                                                                                                                                   |
+-----------------+-----------------------------------------------------------------------------------------------------------------------------------------+
| access          | xxxyyyzzz                                                                                                                               |
| access_token_id | None                                                                                                                                    |
| app_cred_id     | None                                                                                                                                    |
| links           | {'self': 'https://ops.elastx.cloud:5000/v3/users/123/credentials/OS-EC2/456'}                                                           |
| project_id      | 123abc                                                                                                                                  |
| secret          | aaabbbccc123                                                                                                                            |
| trust_id        | None                                                                                                                                    |
| user_id         | efg567                                                                                                                                  |
+-----------------+-----------------------------------------------------------------------------------------------------------------------------------------+
```

Fetch credentials:

```shell
$ openstack ec2 credentials list
+----------------------------------+----------------------------------+----------------------------------+----------------------------------+
| Access                           | Secret                           | Project ID                       | User ID                          |
+----------------------------------+----------------------------------+----------------------------------+----------------------------------+
| xxxyyyzzz                        | aaabbbccc123                     | 123abc                           | efg567                           |
+----------------------------------+----------------------------------+----------------------------------+----------------------------------+
```

## Delete credentials

Make sure you have installed the openstack python client.

Use the _access_ key to refer to the credentials you wish to delete:

```shell
$ openstack ec2 credentials delete xxxyyyzzz
```
