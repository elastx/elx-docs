---
title: "Restrict phpMyAdmin access"
description: "Limit access to your database phpMyAdmin with Apache rules"
weight: 1
alwaysopen: true
---

## Overview
If you want to limit access to the database phpMyAdmin you can use a Apache access rule.

## Configuration
Step 1: In the Jelastic GUI, select "Config" on the database node.

Step 2: Edit the file /conf.d/phpMyAdmin-jel.conf

Step 3a. If you do not have a public IP (which is the default) on the database node set the following configuration with the IP address you want to allow access.
```
<Directory /usr/share/phpMyAdmin/>
Order Allow,Deny
SetEnvIF X-Forwarded-For "1.2.3.4" AllowIP
Allow from env=AllowIP
</Directory>
```
_Note: Make sure to edit the IP in the example to your desired value_

Step 3b: If you have a public IP on the database node set the following configuration with the IP address you want to allow access.
```
<Directory /usr/share/phpMyAdmin/>
Order Allow,Deny
Allow from 1.2.3.4
</Directory>
```
_Note: Make sure to edit the IP in the example to your desired value_

Step 4: Restart the environment or contact support and we can reload the Apache configuration for you.
