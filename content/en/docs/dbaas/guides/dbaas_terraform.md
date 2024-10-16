---
title: "DBaaS with Terraform"
description: "Overview and examples of managing datastores in Elastx DBaaS using Terraform"
weight: 1
alwaysopen: true
---

## Overview

This guide will help you getting started with managing datastores in Elastx DBaaS using Terraform.  
For this we will be using OAuth2 for authentication and the CCX Terraform provider. You can find more information about the latest CCX provider [here](https://registry.terraform.io/providers/severalnines/ccx/latest/docs).

## Good To Know
* Create/Destroy datastores supported.
* Setting firewall rules supported.
* Setting database parameter values supported.
* Scale out/in nodes supported.
* Create users and databases currently not supported.

## DBaaS OAuth2 credentials

Before we get started with terraform, we need to create a new set of OAuth2 credentials.  
In the DBaaS UI, go to your [Account settings](https://dbaas.elastx.cloud/account), select Authorization and choose Create credentials.

In the Create Credentials window, you can add a description and set an expiration date for your new OAuth2 credential.  
Expiration date is based on the number of hours starting from when the credential were created. If left empty, the credential will not have an expiration date. You can however revoke and-/or remove your credentials at any time.  
When you're done select Create.


![Create credential](/img/dbaas/guides/dbaas_terraform_backend-1.png)

---

Copy Client ID and Client Secret. We will be using them to authenticate to DBaaS with Terraform.  
Make sure you've copied and saved the client secret before closing the popup window. The client secret cannot be obtained later and you will have to create a new one.

![Copy credential](/img/dbaas/guides/dbaas_terraform_backend-2.png)

---

## Terraform configuration

We'll start by creating a new, empty file, and adding the Client ID and Secret as variables, which will be exported and used for authenticaton later when we apply our terraform configuration.   
Add your Client ID and Client Secret.
```shell
#!/usr/bin/env bash

export CCX_BASE_URL="https://dbaas.elastx.cloud"
export CCX_CLIENT_ID="<client-id>"
export CCX_CLIENT_SECRET="<client-secret>"
```
Source your newly created credentials file.
```shell
source /path/to/myfile.sh
```

### Terraform provider
Create a new terraform configuration file. In this example we create `provider.tf` and add the CCX provider.
```hc1
terraform {
  required_providers {
    ccx = {
      source = "severalnines/ccx"
      version = "0.3.1"
    }
  }
}
``` 

### Create your first datastore with Terraform
Create an additional terraform configuration file and add your prefered datastore settings. In this example we create a configuration file named `main.tf` and specify that his is a single node datastore with MariaDB.
```hc1
resource "ccx_datastore" "elastx-dbaas" {
  name           = "my-terraform-datastore"
  db_vendor      = "mariadb"
  size           = "1"
  instance_size  = "v2-c2-m8-d80"
  volume_type    = "v2-1k"
  volume_size    = "80"
  cloud_provider = "elastx"
  cloud_region   = "se-sto"
  tags           = ["terraform", "elastx", "mariadb"]
}
```

### Create primary/replica datastores with added firewall rules and database parameter values
This example is built upon the previous MariaDB example. Here we added a second node to create a primary/replica datastore. We're also adding firewall rules and setting database parameter values. To see all available database parameters for your specific database type, log into the DBaaS UI, go to your specific datastore > Settings > DB Parameters.
```hcl
resource "ccx_datastore" "elastx-dbaas" {
  name           = "my-terraform-datastore"
  db_vendor      = "mariadb"
  size           = "2"
  instance_size  = "v2-c2-m8-d80"
  volume_type    = "v2-1k"
  volume_size    = "80"
  cloud_provider = "elastx"
  cloud_region   = "se-sto"
  tags           = ["terraform", "elastx", "mariadb"]

# You can add multiple firewall rules here
  firewall {
    source       = "x.x.x.x/32"
    description  = "My Application"
  }

  firewall {
    source      = "x.x.x.x/32"
    description = "My database client"
  }

# Set your specific database parameter values here. Values should be comma-separated without spaces.
  db_params = {
    sql_mode = "STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER"
  }
 
}
```
### Available options

Below you will find a table with available options you can choose from.

| Resource | Description |
|---|---|
| `name` | *Required* - Sets the name for your new datastore. |
| `db_vendor` | *Required* - Selects which database vendor you want to use. Available options: **mysql, mariadb, redis** and **postgres**. For specific Postgres version see the db_version option.|
| `instance_size` | *Required* - Here you select which flavor you want to use. |-
| `cloud_provider` | *Required* - Should be set to **elastx**. |
| `cloud_region` | *Required* - Should be set to **se-sto**. |
| `volume_type` | *Recommended* - This will create a volume as the default storage instead of the ephemeral disk that is included with the flavor. Select the volume type name for the type of volume you want to use. You can find the full list of available volume types here: [ECP/OpenStack Block Storage](https://elastx.se/en/openstack/specification). |
| `volume_size` | *Recommended* - Required if volume_type is used. Minimum volume size requirement is **80GB**. |
| `db_version` | *Optional* - Only applicable to PostgreSQL. Selects the version of PostgreSQL you want to use. You can choose between 14 and 15. Defaults to **15** if not set. |
| `firewall` | *Optional* - Inline block for adding firewall rules. Can be set multiple times. |
| `db_params`| *Optional* - Inline block for setting specific database parameter values using: parameter="values". Values should be comma-separated. |
| `tags` | *Optional* - Add additional tags. 
