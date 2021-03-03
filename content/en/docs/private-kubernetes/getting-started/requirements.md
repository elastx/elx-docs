---
title: "Requirements"
description: "In order to begin using Private Kubernetes, you need these tools installed"
weight: 1
alwaysopen: true
---

To get started you need certain tools in order to administrate your cluster and applications.

* kubectl
* Knowledge of how Kubernetes works

You also need a configuration file from us called `<yourcluster>-kubeconfig` and if you have access to multiple clusters, you can choose to combine your own `~/.kube/config` or set the environment variable `KUBECONFIG` which both kubectl and helm honors. We will be showing how you do the latter.

> To maintain your own kubeconfig you can read more about the topic in Kubernetes official documentation:  [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)

To install `kubectl` you can follow the official documentation here: [Install and Set Up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/). 

## Verify access

Let's verify that you have access to your cluster.

```bash
$ export KUBECONFIG=elastx-example1-kubeconfig
$ kubectl get nodes
NAME                           STATUS   ROLES    AGE   VERSION
elastx-example1-k8s-master-1   Ready    master   5d    v1.10.4
elastx-example1-k8s-master-2   Ready    master   5d    v1.10.4
elastx-example1-k8s-master-3   Ready    master   5d    v1.10.4
elastx-example1-k8s-node-1     Ready    node     5d    v1.10.4
elastx-example1-k8s-node-2     Ready    node     5d    v1.10.4
elastx-example1-k8s-node-3     Ready    node     5d    v1.10.4
```

> CAUTION: The *kubeconfig* you get from us has full administrator privileges.
