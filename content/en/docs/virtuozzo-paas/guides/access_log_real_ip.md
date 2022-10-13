---
title: "Log real client IP behind a proxy"
description: "How to log the client's real IP behind a proxy"
weight: 1
alwaysopen: true
---

## Overview

This guide will demonstrate how to make your web server log your client's real IP instead of the proxy's. 
This is applicable both if your web server is behind your own proxy or our Jelastic resolver.

## Nginx Configuration

Replace `$remote_addr` with `$http_x_real_ip` in your nginx.conf where the log format is defined. 

This is what is should look like:

```
    log_format  main  '$http_x_real_ip:$http_x_remote_port - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for" '
                      '"$host" sn="$server_name" '
                      'rt=$request_time '
                      'ua="$upstream_addr" us="$upstream_status" '
                      'ut="$upstream_response_time" ul="$upstream_response_length" '
                      'cs=$upstream_cache_status' ; 
```

And this is the default value, note that the only change is on the first row.

```
    log_format  main  '$remote_addr:$http_x_remote_port - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for" '
                      '"$host" sn="$server_name" '
                      'rt=$request_time '
                      'ua="$upstream_addr" us="$upstream_status" '
                      'ut="$upstream_response_time" ul="$upstream_response_length" '
                      'cs=$upstream_cache_status' ;
```

Your nginx access log will now contain the client's real IP instead of the proxy's.

## Apache Configuration

For Apache you'll need to change the LogFormat in your httpd.conf to the following:

```
LogFormat "%{X-Real-IP}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%{X-Real-IP}i %l %u %t \"%r\" %>s %b" common
```

The default values to be replaced are:
```
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%h %l %u %t \"%r\" %>s %b" common
```

Done, your Apache access log will now contain the client's real IP instead of the proxy's.
