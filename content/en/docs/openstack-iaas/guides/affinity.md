---
title: "Affinity Policy"
description: "Guide for using Affinity Policies"
weight: 1
alwaysopen: true
---
## Overview
This is a guide on how to make sure the a group of instances do not run on the same compute node. For example if you want to run a cluster of instances you do not want multiple instances to fail if a compute node fails.

1. Create an anti affinity group.  
```nova server-group-create testgroup anti-affinity```

1. (Optional) Read out the affinity policies.  
```nova server-group-list | grep -Ei "Policies|affinity"```

1. Add the instance to the group when deploying.  
```nova boot --image IMAGE_ID --flavor m1.small --hint group=SERVER_GROUP_UUID cluster-node-1 ```

## Additional links
This is relevant to the "Train" version of Openstack:
https://docs.openstack.org/senlin/train/user/policy_types/affinity.html
