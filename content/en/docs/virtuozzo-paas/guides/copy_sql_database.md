---
title: "Copy a SQL database"
description: "How to copy a SQL database between evironments"
weight: 1
alwaysopen: true
---

## Overview

This guide will walk you through the procedure of copying a SQL database between environments using the Jelastic GUI.

## Export the database

1. Open up phpMyAdmin on the source environment by clicking the icon as shown below

![Open-in-browser](/img/jelastic-paas/guides/jel_copy-sql-1.png)

2. Export the database by first choosing the database to the left, in our case example, and then click on Export on the top navigation bar. Make sure to check the box where it says "Save on server in the directory /var/lib/jelastic/phpMyAdmin/save" and then click "Go".

![phpMyAdmin-export](/img/jelastic-paas/guides/jel_copy-sql-2.png)

4. Now you have exported the database.

## Share folder between environments

1. Find the configuration wrench on the *SQL Databases* source node.

![Configuration-wrench](/img/jelastic-paas/guides/jel_copy-sql-3.png)

2. Go to folder /var/lib/jelastic/phpMyAdmin. Click the cogwheel on the save folder as shown on the image below and choose *Export*

![Export-folder](/img/jelastic-paas/guides/jel_copy-sql-4.png)

3. Make sure to choose the correct target container where your target SQL database is at.

![Select-target-container](/img/jelastic-paas/guides/jel_copy-sql-5.png)

4. Make sure to use the path /var/lib/jelastic/phpMyAdmin/upload

![Set-path](/img/jelastic-paas/guides/jel_copy-sql-6.png)

5. Now the target environment should have access to a folder on the source environment.

## Import the database

1. Open up phpMyAdmin on the *target* environment.

![Open-in-browser](/img/jelastic-paas/guides/jel_copy-sql-7.png)

2. In order to import the database, we need to create it beforehand as shown below.

![Create-db](/img/jelastic-paas/guides/jel_copy-sql-8.png)

3. Since you have mounted the source environments save folder to the target environments upload folder, you have access to the sql files there. So click on "Select from the web server upload directory **/var/lib/jelastic/phpMyAdmin/upload/**" and click *Go* to import it.

![Import-database](/img/jelastic-paas/guides/jel_copy-sql-9.png)

4. At this time, you should have a successful import.

## Cleanup - unmount the shared folder

1. When you are done exporting and importing databases, you should remove the shared folder. Click on the wrench on the target environments database node.

![Configuration-wrench](/img/jelastic-paas/guides/jel_copy-sql-10.png)

2. You should see the upload folder in your *Mount Points* folder below to the left. Click the cogwheel and unmount, as shown in the image below

![Unmount-folder](/img/jelastic-paas/guides/jel_copy-sql-11.png)

You should be all set!
