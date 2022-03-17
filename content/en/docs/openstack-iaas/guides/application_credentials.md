---
title: "Application credentials"
description: "Guide to get started with application credentials"
weight: 1
alwaysopen: true
---

## Overview

This guide will help you getting started with OpenStack application credentials.
Application credentials are designed to be used by automation and CLI tools, such as Terraform and the [OpenStack command-line client](https://docs.openstack.org/python-openstackclient/rocky/).

## Create application credential using web dashboard

Navigate to ["Identity" → "Application Credentials"](https://ops.elastx.cloud/identity/application_credentials/) in your target project and press "Create Application Credential".
Once created, you'll be offered to download the generated credential configuration as an OpenStack RC file ("openrc" version 3) or in the "clouds.yaml" format.


## Create application credential using CLI

To create a pair of application credentials run the `openstack application credential create <name>` command. By default the same access as the user running the command will be given. If you wish to override the roles given add `--role <role>` for each role you want to add.

You can also set an expiration date when creating a pair of application credentials, add the flag `--expiration` followed by a timestamp in the following format: `YYYY-mm-ddTHH:MM:SS`.

For more detail you can [visit the OpenStack documentation](https://docs.openstack.org/python-openstackclient/rocky/cli/command-objects/application-credentials.html) that goes more into detail on all avaible options.

An example that will give access to the most commonly used APIs:

```bash
openstack application credential create test --role _member_ --role creator --role load-balancer_member

+--------------+----------------------------------------------------------------------------------------+
| Field        | Value                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
| description  | None                                                                                   |
| expires_at   | None                                                                                   |
| id           | 3cd933bbcf824bdc9f77f37692eea60a                                                       |
| name         | test                                                                                   |
| project_id   | bb301d6172f54d749f9aa3094d77eeef                                                       |
| roles        | _member_ creator load-balancer_member                                                  |
| secret       | ibHyYuIPQCf-IKVN0qOEAgf4CNvDWmT5ltI6mdbmUTMD7OvJTu-5nXX0U6_5EOXTKriq7C7Ka06wKmJa0yLcKg |
| unrestricted | False                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
```

> **Beware:** You will not be able to view the secret again after creation. In case you forget the secret you will need to delete and create a new pair of application credentials.

### Create an openrc file

```bash
#!/usr/bin/env bash
export OS_AUTH_TYPE=v3applicationcredential
export OS_AUTH_URL=https://ops.elastx.cloud:5000/v3
export OS_APPLICATION_CREDENTIAL_ID="<ID>"
export OS_APPLICATION_CREDENTIAL_SECRET="<SECRET>"
export OS_REGION_NAME="se-sto"
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3
```

## Available roles

Below you will find a table with available roles and what they mean.

| Role name | Description |
|---|---|
| `_member_` | Gives access to nova, neutron and glance. This allowed to manage servers, networks, security groups and images (this role is currently always given) |
| `creator` | Gives access to barbican. The account can create and read secrets, this permission is also requierd when creating an encrypted volumes |
| `heat_stack_owner` | Gives access to manage heat |
| `load-balancer_member` | Gives access to create and manage existing load-balancers |
| `swiftoperator` | Gives access to object storage (all buckets) |


## List application credentials using CLI

To list all existing application credentials available in your project you can run the `openstack application credential list` command.

Example:

```bash
openstack application credential list

+----------------------------------+------+----------------------------------+-------------+------------+
| ID                               | Name | Project ID                       | Description | Expires At |
+----------------------------------+------+----------------------------------+-------------+------------+
| 3cd933bbcf824bdc9f77f37692eea60a | test | bb301d6172f54d749f9aa3094d77eeef | None        | None       |
+----------------------------------+------+----------------------------------+-------------+------------+
```

## Show application credential permissions using CLI

To show which permissions a set of application credentials have you can run the `openstack application credential show` command followed by the ID of the credential you want to inspect.

Example:

```bash
openstack application credential show 3cd933bbcf824bdc9f77f37692eea60a

+--------------+------------------------------------------------------------------------------------+
| Field        | Value                                                                              |
+--------------+------------------------------------------------------------------------------------+
| description  | None                                                                               |
| expires_at   | None                                                                               |
| id           | 3cd933bbcf824bdc9f77f37692eea60a                                                   |
| name         | test                                                                               |
| project_id   | bb301d6172f54d749f9aa3094d77eeef                                                   |
| roles        | creator load-balancer_member _member_                                              |
| unrestricted | False                                                                              |
+--------------+------------------------------------------------------------------------------------+

```

## Delete application credentials using CLI

To delete a pair of application credentials enter the `openstack application credential delete` command followed by the ID of the credentials you want to remove.

Example:

```bash
openstack application credential delete 3cd933bbcf824bdc9f77f37692eea60a
```
