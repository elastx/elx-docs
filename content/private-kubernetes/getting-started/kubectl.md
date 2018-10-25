---
title: "Requirements"
weight: 1
---

To get started you need certain tools in order to administrate your cluster and applications.

* kubectl
* helm (optional)

You also need a configuration file from us called `<yourcluster>-kubeconfig` and if you have access to multiple clusters, you can choose to combine your own `~/.kube/config` or set the environment variable `KUBECONFIG` which both kubectl and helm honors. We will be showing how you do the latter. But if you want to know how to maintain your own kubeconfig you can read more about the topic at the official documentation about [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)
