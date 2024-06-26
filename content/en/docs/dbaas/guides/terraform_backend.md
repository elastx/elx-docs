---
title: "Terraform backend"
description: "Overview and example configuration"
weight: 1
alwaysopen: true
---

## Overview

This guide will help you getting started with creating datastores in Elastx DBaaS using Terraform.  
For this we will be using OAuth2 for authentication and the CCX Terraform provider.  
You can find information about the latest CCX provider <a href="https://registry.terraform.io/providers/severalnines/ccx/latest/docs">here</a>.

## Known Limitations
Currently only datastores can be deployed using the CCX provider. Database users and databases needs to be added through the DBaaS UI.

## DBaaS OAuth2 credentials

Before we get started with terraform, we need to create a new set of OAuth2 credentials.  
In the DBaaS UI, go to your [Account settings](https://dbaas.elastx.cloud/account) and select **Authorization** and choose **Create credentials**.

---

In the *Create Credentials*  window, you can add a description and set an expiration date for your new OAuth2 credential.  
Expiration date is based on the number of hours starting from when the credential were created. If left empty, the credential will not have an expiration date. You can however revoke and-/or remove your credentials at any time.  
When you're done select Create.


![Create credential](/img/dbaas/guides/dbaas_terraform_backend-1.png)

---

Copy Client ID and Client Secret. We will be using them to authenticate to DBaaS with Terraform.  
Make sure you've copied and saved the client secret before you close the dialog. The client secret value cannot be obtained later and you will have to create a new one.

![Copy credential](/img/dbaas/guides/dbaas_terraform_backend-2.png)

---

## Terraform configuration

Create a new file locally with the variables below and add your Client ID and Client Secret.
```json
#!/usr/bin/env bash

export CCX_BASE_URL="https://dbaas.elastx.cloud"
export CCX_CLIENT_ID="<client-id>"
export CCX_CLIENT_SECRET="<client-secret>"
```
Source your newly created credentials file.
```json
source /path/to/myfile.sh
```

### Terraform provider
Create a new terraform configuration file. In this example we create `provider.tf` and add the CCX provider.
```json
terraform {
  required_providers {
    ccx = {
      source = "severalnines/ccx"
      version = "0.2.4"
    }
  }
}
``` 

### Create your first datastore with Terraform
Create an additional terraform configuration file and add your prefered datastore settings. In this example we create a configuration file named `main.tf` and specify that his is a single node datastore with MariaDB.
```json
resource "ccx_datastore" "elastx-dbaas" {
  name           = "my-terraform-datastore"
  db_vendor      = "mariadb"
  instance_size  = "v1-c2-m8-d80"
  volume_type    = "v2-1k"
  volume_size    = "80"
  cloud_provider = "elastx"
  cloud_region   = "se-sto"
  tags           = ["terraform", "elastx", "mariadb"]
}
```
### Available options

Below you will find a table with available options you can choose from.

| Resource | Description |
|---|---|
| `name` | *Required* - Sets a name for your new datastore. |
| `db_vendor` | *Required* - Selects which database vendor you want to use. Available options: **mysql, mariadb, redis** and **postgres**. For specific Postgres version see the db_version option.|
| `instance_size` | *Required* - Here you select which flavor you want to use. |-
| `cloud_provider` | *Required* - Should be set to **elastx**. |
| `cloud_region` | *Required* - Should be set to **se-sto**. |
| `volume_type` | *Recommended* - This will create a volume as the default storage instead of the ephemeral disk that is included with the flavor. Select the volume name for the type of volume you want to use. You can find the full list of available volume types here: [ECP/OpenStack Block Storage](https://elastx.se/en/openstack/specification). |
| `volume_size` | *Recommended* - Required if volume_type is used. Minimum volume size requirement is **80GB**. |
| `size` | *Optional* - This is the size of your datastore cluster. Depending on the datastore type, you can choose between: **1** (single node), **2** (two nodes), **3** (three nodes). Defaults to **1**. |
| `db_version` | *Optional* - Only applicable to PostgreSQL. Select the version of PostgreSQL you want to use. You can choose between 11, 14 and 15. Defaults to **15** if not set. |
| `tags` | *Optional* - Add additional tags. 
