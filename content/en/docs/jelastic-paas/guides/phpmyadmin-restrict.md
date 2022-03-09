---
title: "Restrict phpMyAdmin access"
description: "Limit access to your database phpMyAdmin with Apache rules"
weight: 1
alwaysopen: true
---

## Overview
If you want to limit access to the database phpMyAdmin you can use a Apache access rule.

## Configuration
1. In the Jelastic GUI, select "Config" on the database node.

2. Edit the file /conf.d/phpMyAdmin-jel.conf and make sure your `<Directory /usr/share/phpMyAdmin/>` looks like this. Edit the IP to the IP that should be granted access.

```
<Directory /usr/share/phpMyAdmin/>
     SetEnvIf X-Forwarded-For ^xxx\.xxx\.xxx\.xxx env_allow_1
     Require env env_allow_1
     Require ip xxx.xxx.xxx.xxx
     Require all denied
</Directory>
```
_Note: Make sure to edit the IP in the example to your desired value_

3. Restart the environment or contact support and we can reload the Apache configuration for you.
