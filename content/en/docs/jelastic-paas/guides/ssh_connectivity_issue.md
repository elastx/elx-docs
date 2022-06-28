---
title: "SSH Connectivity issue"
description: "Solution for SSH Connectivity issue"
weight: 1
alwaysopen: true
---

## Overview

In case you are experiencing connectivity issues and no longer can use SSH to login into your containers - one possible underlying cause for this issue could be some missing files which are required in order for SSH to properly work.

In the /home/ directory, there is expected to be a .bash_profile and a subdirectory with /$USER/.ssh/authorized_keys

$USER in this case could for example be jelastic or memcache - depending on your environment.

Content in /$USER/.ssh/authorized_keys can be copied from /root/.ssh/authorized_keys. You should also make sure authorized_keys have proper permissions, which should be -rw------- (chmod 600) and also must have proper owner/group set to $USER:$USER (for example jelastic:jelastic)
