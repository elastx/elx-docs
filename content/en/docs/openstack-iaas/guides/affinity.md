---
title: "Affinity Policy"
description: "Guide for using Affinity Policies"
weight: 1
alwaysopen: true
---
## Overview
Here is how to avoid that groups of instances run on the same compute node. This can be relevant when configuring resilience.

1. Create an anti affinity group.    
Take note of the group UUID that is displayed when created. It is needed when deploying the instance.  
```openstack server group create --policy anti-affinity testgroup```  

     https://docs.openstack.org/python-openstackclient/train/cli/command-objects/server-group.html


1. (Optional) Read out the affinity policies.  
```openstack server group list | grep -Ei "Policies|affinity"```

1. Add the instance to the group when deploying.  
```openstack server create --image ubuntu-20.04-server-latest --flavor v1-small-1 --hint group=<server_group_uuid> test-instance```

    https://docs.openstack.org/python-openstackclient/train/cli/command-objects/server.html

## Additional links
https://docs.openstack.org/senlin/train/user/policy_types/affinity.html
