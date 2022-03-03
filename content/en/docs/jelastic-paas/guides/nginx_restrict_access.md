---
title: "Nginx access restriction"
description: "Restrict access to your nginx server"
weight: 1
alwaysopen: true
---

## Overview

If you want to restrict access to your web site by limiting the source IP addresses that can access the site this is how you do it. Replace the IP addresses with the IP you want to allow access from.

## Edit nginx.conf.

Add the following to the server section in nginx.conf.


```bash
allow 1.2.3.4;
allow 5.6.7.8; 
deny all;
```

If you don't have a public IP on your nginx then add the following to the http section in nginx.conf.

```bash
real_ip_header X-Forwarded-For; 
set_real_ip_from 10.0.0.0/8;
real_ip_recursive on;
```

