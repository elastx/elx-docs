---
title: "Nginx redirect to HTTPS"
description: "Redirect all traffic to https in nginx"
weight: 1
alwaysopen: true
---

## Overview

If you have enabled https, have a public IP and want to redirect all traffic from http to https you can change the "/ location {}" section in nginx.conf to the following.


```bash
location / {
  rewrite ^ https://$host$request_uri? permanent;
}
```

If your webserver is located behind a proxy, loadbalancer or WAF (that sends x-forwarded headers) you can simply use the below snippet instead.

```bash
if ($http_x_forwarded_proto != "https") {
  rewrite ^ https://$host$request_uri? permanent;
}
```

