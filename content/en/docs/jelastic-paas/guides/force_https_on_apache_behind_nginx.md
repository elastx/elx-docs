---
title: "Force HTTPS on Apache behind Nginx load balancer"
description: "How to force HTTPS on apache with Nginx load balancer"
weight: 1
alwaysopen: true
---

## Edit httd.conf

Add the following configuration in the apache configuration file `httd.conf`.


```shell
<VirtualHost *:80>
...
RewriteEngine on
RewriteCond %{HTTP:X-Forwarded-Proto} !https
RewriteRule .* https://%{HTTP_HOST}%{REQUEST_URI} [R,L]
</VirtualHost>
```
