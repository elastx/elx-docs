---
title: "API access"
description: "Consumption of OpenStack REST APIs"
weight: 1
alwaysopen: true
---

## Introduction
OpenStack provides REST APIs for programmatic interaction with the various services (compute, object storage, etc.).
These APIs are used by automation tools such as
[HashiCorp Terraform](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs) and
the [OpenStack CLI utility](https://docs.openstack.org/python-openstackclient/latest/).  
  
For advanced programmatic usage, there exist freely available
[SDKs and software libraries for several languages](https://wiki.openstack.org/wiki/SDKs) which are maintained by the
OpenStack project or community members.  
  
This guides describes the initial steps required for manual usage of the OpenStack REST APIs.


## Authentication
Usage of an [application credential](../application_credentials/) for API authentication is recommend due to their
security and operational benefits.


## Listing endpoints
API endpoints for the OpenStack services can be listed by navigating to
["Project" → "API Access" in the Horizon web console](https://ops.elastx.cloud/project/api_access/) or by issuing the
following command:

```bash
$ openstack catalog list
```

Endpoints marked as "public" in the command output are intended for customer usage.


## Reference documentation
For detailed usage of the of the APIs, see the
[official OpenStack API reference documentation](https://docs.openstack.org/train/api/) (version "Train").
