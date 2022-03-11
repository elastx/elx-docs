---
title: "Copy files between environments"
description: "How to copy files between environments"
weight: 1
alwaysopen: true
---

## Overview

This guide will help you getting started with moving files between environments using the Jelastic GUI.

## Export directory

1. Find the configuration wrench on the Application Servers source node.

![Find-configuration-wrench](/img/jelastic-paas/guides/jel_copy-files-1.png)

2. Go to folder `/var/www/webroot` (via favorites to the left). Click the cogwheel on the ROOT folder as shown on the image below and choose Export

![Go-to-folder](/img/jelastic-paas/guides/jel_copy-files-2.png)

3. Make sure to choose the correct target container where your target Application Server is at.

![Choose-correct-target](/img/jelastic-paas/guides/jel_copy-files-3.png)

4. Here we use the path `/var/www/webroot/FROM_SOURCE` which will create and mount this folder on the source environments Application Server.

![Use-path](/img/jelastic-paas/guides/jel_copy-files-4.png)

## Copy files

5. Click the configuration wrench on the target environment's Application Server.

![Configuration-wrench-target](/img/jelastic-paas/guides/jel_copy-files-5.png)

6. To the left, click the cogwheel and click Copy Path, which will copy the full path location to your clipboard.

![Copy-path](/img/jelastic-paas/guides/jel_copy-files-6.png)

7. Click on the terminal icon to engage the Web SSH terminal

![Open-terminal](/img/jelastic-paas/guides/jel_copy-files-7.png)

8. In the terminal you should write `cd` then paste previously copied path `/var/www/webroot` and then enter. After that you should see the folder `FROM_SOURCE` executing `ls -l` as shown on the image below.

![See-FROM-SOURCE](/img/jelastic-paas/guides/jel_copy-files-8.png)

9. Now you should be able to copy files as shown below. Using the `--verbose` flags gives you this output.

![Copy-files](/img/jelastic-paas/guides/jel_copy-files-9.png)

10. You can confirm that the files been copied by browsing to that folder in the GUI.

![Confirm-files](/img/jelastic-paas/guides/jel_copy-files-10.png)

## Clean up

11. Unmount the exported directory on the target application server as shown below.

![Clean-up](/img/jelastic-paas/guides/jel_copy-files-11.png)
