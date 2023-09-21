---
title: "Auto Scaling"
description: "Automatically scale your kubernetes nodes"
weight: 5
alwaysopen: true

---

We now offer autoscaling of nodes.

## What is a nodegroup?

In order to simplify node management we now have nodegroup.

A nodegroup is a set of nodes, They span over all 3 of our availability zones.
All nodes in a nodegroup are using the same flavour. This means if you want to mix flavours in your cluster there will be at least one nodegroup per flavor. We can also create custom nodegroups upon requests meaning you can have 2 nodegroups with the same flavour.

By default clusters are created with one nodegroup called "worker".
When listing nodes by running `kubectl get nodes` you can see the node group by looking at the nodes name. All node names begin with `clustername` - `nodegroup`. 

In the example below we have the cluster `hux-lab1` and can see the default workers are located in the nodegroup `worker` and additionally, the added nodegroup `nodegroup2` with a few extra nodes.

```bash
❯ kubectl get nodes
NAME                           STATUS   ROLES           AGE     VERSION
hux-lab1-control-plane-c9bmm   Ready    control-plane   2d18h   v1.27.3
hux-lab1-control-plane-j5p42   Ready    control-plane   2d18h   v1.27.3
hux-lab1-control-plane-wlwr8   Ready    control-plane   2d18h   v1.27.3
hux-lab1-worker-447sn          Ready    <none>          2d18h   v1.27.3
hux-lab1-worker-9ltbp          Ready    <none>          2d18h   v1.27.3
hux-lab1-worker-htfbp          Ready    <none>          15h     v1.27.3
hux-lab1-worker-k56hn          Ready    <none>          16h     v1.27.3
hux-lab1-nodegroup2-33hbp      Ready    <none>          15h     v1.27.3
hux-lab1-nodegroup2-54j5k      Ready    <none>          16h     v1.27.3
```

## How to activate autoscaling?

Autoscaling currently needs to be configured by Elastx support.

In order to activate auto scaling we need to know `clustername` and `nodegroup` with two values for `minimum/maximum` number of desired nodes.

Nodes are split into availability zones meaning if you want 3 nodes you get one in each availability zone.

Another example is to have a minimum of 3 nodes and maximum of 7. This would translate to minimum one node per availability zone and maximum 3 in STO1 and 2 in STO2 and STO3 respectively.
To keep it simple we recommend using increments of 3.

If you are unsure contact out support and we will help you get the configuration you wish for.

## How does autoscaling know when to add additional nodes?

Nodes are added when they are needed. There are two scenarios:

1. You have a pod that fails to be scheduled on existing nodes
2. You scheduled pods with requests and the autoscaler senses that your pods won't be able to be scheduled on the available nodes. If a lot of pods are scheduled this method can add more than one node at a time.

## Can I disable auto scaling after activating it?

Yes, just contact Elastx support and we will help you with this.

When disabling auto scaling node count will be locked. Contact support if the number if nodes you wish to keep deviates from current amount od nodes, and we will scale it for you.
