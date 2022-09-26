---
title: "Terraform Backend"
description: "Overview and example configuration"
weight: 1
alwaysopen: true
---

## Overview

Swift is accessable with the s3 backend. To get the access and secret key follow this guide. [EC2 credentials](../ec2_credentials/)

## Example configuration

This is what you need to get the s3 backend to work with swift.

```json
backend "s3" {
  bucket = "<The bucket you want to use>"
  key    = "<Path and name to tf state file>"
  endpoint   = "https://swift.elastx.cloud"
  sts_endpoint = "https://swift.elastx.cloud"
  access_key = "<Puth your access key here>"
  secret_key = "<Put your secret key here>"
  region = "us-east-1"
  force_path_style = "true"
  skip_credentials_validation = "true"
}
```
key variable example: "path/to/tf-state-file".

This is the path in the bucket.