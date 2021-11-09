---
title: "Swift S3 compatibility"
description: "Swift S3 compatibility"
weight: 1
alwaysopen: true
---

## Overview

Swift provides an S3 compatible API for applications that don't support the Swift API. Note that you need to create [EC2 credentials](../ec2_credentials/) for this to work.

*NOTE: The S3 region must be set to "us-east-1" for compatibility with "AWS Signature Version 4"*

*NOTE: If the application does support Swift natively, this will provide superior performance and generally a better experience.*

## Example s3cmd configuration

The configuration below works with s3cmd:

```ini
[default]
access_key = 00000000000000000000000000000
secret_key = 00000000000000000000000000000
host_base = swift.elastx.cloud
host_bucket = swift.elastx.cloud
use_https = True
bucket_location = us-east-1
```
