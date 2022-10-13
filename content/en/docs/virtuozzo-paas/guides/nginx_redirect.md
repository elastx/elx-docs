---
title: "Redirect nginx"
description: "How to redirect traffic in nginx"
weight: 1
alwaysopen: true
---

## Overview

If you want to make sure all traffic only uses your preferred domain name you can create a new server {} block that redirects to the preferred domain name.

## Edit nginx.conf

On your nginx node select config and edit the nginx.conf file.
In this example we'll redirect my-site.jelastic.elastx.net to https://my-domain.tld


```shell
server {
    server_name my-site.jelastic.elastx.net;
    listen 80 default_server;
    return 301 https://my-domain.tld/$request_uri;
}

```
