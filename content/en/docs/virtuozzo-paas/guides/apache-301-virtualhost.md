---
title: "Catch-all VirtualHost with 301 redirect on Apache"
description: "Create an Apache 301 redirect rule to redirect traffic to your domain"
weight: 1
alwaysopen: true
---

## Overview

If you want to make sure all traffic only uses your preferred domain name you can create a catch-all VirtualHost in Apache and redirect to the VirtualHost with the preferred domain name.

## Configuration

On your apache node select config and edit the `httpd.conf` file. 
Replace the current `<VirtualHost ...>` section with the following and replace `mydomain.com` with your domain name.

_Note: Before you make any changes, it is always recommended to create a backup copy of the old configuration file._

```
<VirtualHost *:80>
 DocumentRoot /var/www/webroot/ROOT
 ServerName mydomain.com
 ErrorLog logs/mydomain-error_log
 CustomLog logs/mydomain-access_log common
</VirtualHost>
<VirtualHost *:80>
 ServerName www.mydomain.com
 ServerAlias *
 Redirect 301 / http://mydomain.com/
 ErrorLog logs/redirect-error_log
 CustomLog logs/redirect-access_log common
</VirtualHost>
```

In this example all traffic that is not `http://mydomain.com` will be redirected to that domain.
