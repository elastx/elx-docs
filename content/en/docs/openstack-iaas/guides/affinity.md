---
title: "Affinity Policy"
description: "Guide for using Affinity Policies"
weight: 1
alwaysopen: true
---

## Overview
This is a guide on how to make sure the group of instances do not run on the same compute node. For example if you want to run a cluster of instances you do not want multiple instances to fail if a compute node fails.

1. Create an anti affinity group.    
Take note of the group UUID that is displayed when created. It will be used when deploying the instance soon.  
```openstack server group create --policy anti-affinity testgroup```  

1. (Optional) Read out the affinity policies.  
```openstack server group list | grep -Ei "Policies|affinity"```

1. Add the instance to the group when deploying.  
```openstack server create --image ubuntu-20.04-server-latest --flavor v1-small-1 --hint group=<server_group_uuid> test-instance```

## Additional links
This is relevant to the "Train" version of Openstack:
https://docs.openstack.org/senlin/train/user/policy_types/affinity.html

Info: https://docs.openstack.org/python-openstackclient/train/cli/command-objects/server-group.html

Info: https://docs.openstack.org/python-openstackclient/train/cli/command-objects/server.html