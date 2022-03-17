---
title: "Nginx HTTP to HTTPS redirect"
description: "Redirect to https in nginx load balancer"
weight: 1
alwaysopen: true
---

## Overview

If you have an nginx load balancer in you environment and want to redirect all requests to https then you can add the following configuration.


## nginx configuration

On the nginx load balancer node select config and create a new file under conf.d named redirect.conf.
Add the following configuration to the file, save it and restart nginx.


```shell
server {
       listen *:80 default_server;
       access_log /var/log/nginx/redirect.access_log main;
       error_log /var/log/nginx/redirect.error_log info;
       location / {
         rewrite ^ https://$host$request_uri? permanent;
       }
}
```

