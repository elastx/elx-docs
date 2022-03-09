---
title: "Restrict access to your nginx server"
description: "Restrict web access with nginx allow, deny"
weight: 1
alwaysopen: true
---

## Overview
If you want to restrict access to your web site by limiting the source IP addresses that can access the site this can be achieved via the `nginx.conf` configuration file.

## Edit nginx.conf
Replace the IP addresses with the IP(s) you want to allow access from.
Add the following to the server section in nginx.conf.
```
allow 1.2.3.4; # Allow a single IP
allow 5.6.7.8; # Allow another IP
deny all; # Deny the rest
```

If you don't have a public IP on your nginx then add the following to the http section in `nginx.conf`.
```
real_ip_header X-Forwarded-For; 
set_real_ip_from 10.0.0.0/8;
real_ip_recursive on;
```
