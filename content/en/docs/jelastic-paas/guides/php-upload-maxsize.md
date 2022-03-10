---
title: "PHP Max upload file size"
description: "How to adjust the PHP max upload file size"
weight: 1
alwaysopen: true
---

## Overview

This guide demonstrates how to increase (or decrease) the PHP max upload file size. We'll need to both configure PHP and then the web server if you're running nginx.


## PHP Configuration

In php.ini, find the rows containing `upload_max_filesize` and `post_max_size` and change their values to the desired amount.

By default they will look something like this, depending on what type of node you're running their values might differ:

```php
upload_max_filesize = 100M
post_max_size = 100M          ; Maximum size of POST data that PHP will accept.
```

Continue with the web server configuration below.

## Nginx Configuration

If you are running nginx you will need to edit (or add if it's missing) the following row with the desired value in the `http {}` block in nginx.conf.

`client_max_body_size 32m;`

Restart the node for the changes to take effect.
