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

In order to activate auto scaling we need to know `clustername` and `nodegroup` with two values for `minimum/maximum` number of desired nodes. Currently we cannot have minimum set below 3 nodes however this is subnject to vhange in the future.

Nodes are split into availability zones meaning if you want 3 nodes you get one in each availability zone.

Another example is to have a minimum of 3 nodes and maximum of 7. This would translate to minimum one node per availability zone and maximum 3 in STO1 and 2 in STO2 and STO3 respectively.
To keep it simple we recommend using increments of 3.

If you are unsure contact out support and we will help you get the configuration you wish for.

## How does autoscaling know when to add additional nodes?

Nodes are added when they are needed. There are two scenarios:

1. You have a pod that fails to be scheduled on existing nodes
2. Scheduled pods requests more then 100% of any resource, this method is smart and senses the amount of resources per node and can therfor add more than one node at a time if required.

## When does the autoscaler scale down nodes?

The autoscaler removes nodes when it senses there is enough free resources to accomodate all current workload (based on requests) on fewer nodes. To avoid all nodes having 100% resource requests (and thereby usage), there is also a built-in mechanism to ensure there is always at least 50% of a node available resources to accept additional requests.

Meaning if you have a nodegroup with 3 nodes and all of them have 4 CPU cores you need to have a total of 2 CPU cores that is not requested per any workload.

To refrain from triggering the auto-scaling feature excessively, there is a built in delay of 10 minutes for scale down actions to occur. Scale up events are triggered immediately.

## Can I disable auto scaling after activating it?

Yes, just contact Elastx support and we will help you with this.

When disabling auto scaling node count will be locked. Contact support if the number if nodes you wish to keep deviates from current amount od nodes, and we will scale it for you.
