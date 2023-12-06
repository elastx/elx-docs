---
title: "Accessing your cluster"
description: "How to access your cluster"
weight: 2
alwaysopen: true
---

In order to access your cluster there are a couple of things you need to do.
First you need to make sure you have the correct tools installed, the default
client for interacting with Kubernetes clusters is called
[kubectl](https://kubernetes.io/docs/tasks/tools/). Instructions for
installing it on your system can be found by following the link.

You may of course use any Kubernetes client you wish to access your cluster
however setting up other clients is beyond the scope of this documentation.

# Credentials (kubeconfig)

Once you have a client you can use to access the cluster you will need to fetch
the credentials for you cluster. You can find the credentials for your cluster
by logging in to [Elastx OpenStack IaaS](https://ops.elastx.cloud/).
When logged in you can find the `kubeconfig` file for your cluster by clicking
on the "Object Storage" menu option in the left-hand side menu. And then click
on "Containers", you should now see a container with the same name as your cluster
(clusters are named "customer-cluster_name"). Clicking on the container should
reveal a file called `admin.conf` in the right-hand pane. Click on the
`Download" button to the right of the file name to download it to your computer.

**NOTE**
These credentials will be rotated when your cluster is upgraded so you should
periodically fetch new credentials to make sure you have a fresh set.

**NOTE**
The kubeconfig you just downloaded has full administrator privileges.

## Configuring kubectl to use your credentials

In order for kubectl to be able to use the credentials you just downloaded you
need to either place the credentials in the default location or otherwise
configure kubectl to utilize them. [The official
documentation](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)
covers this process in detail.

# Verify access

To verify you've got access to the cluster you can run something like this:

```bash
$ kubectl get nodes
NAME                           STATUS   ROLES           AGE   VERSION
hux-lab1-control-plane-c9bmm   Ready    control-plane   14h   v1.27.3
hux-lab1-control-plane-j5p42   Ready    control-plane   14h   v1.27.3
hux-lab1-control-plane-wlwr8   Ready    control-plane   14h   v1.27.3
hux-lab1-worker-447sn          Ready    <none>          13h   v1.27.3
hux-lab1-worker-9ltbp          Ready    <none>          14h   v1.27.3
hux-lab1-worker-vszmc          Ready    <none>          14h   v1.27.3
```

If your output looks similar then you should be good to go! If it looks very
different or contains error messages, don't hesitate to contact our support if
you can't figure out how to solve it on your own.

# Instructions for older versions

Everything under this section is only for clusters running older versions of our private Kubernetes service.

## Security groups

> **Note:** This part only applies to clusters not already running Private Kubernetes 2.0 or later.

If your cluster was created prior to Kubernetes 1.26 or when we specifically informed you that this part applies.

If you are not sure if this part applies, you can validate it by checking if there is a security group called _cluster-name-master-customer_ in your openstack project.

To do so, log in to [Elastx Openstack IaaS](https://ops.elastx.cloud/). When logged
in click on the "Network" menu option in the left-hand side menu. Then click on
"Security Groups", finally click on the "Manage Rules" button to the right of
the security group named _cluster-name-master-customer_. To add a rule click on
the "Add Rule" button.

For example, to allow access from the ip address _1.2.3.4_ configure the rule as
follows:

    Rule: Custom TCP Rule
    Direction: Ingress
    Open Port: Port
    Port: 6443
    Remote: CIDR
    CIDR: 1.2.3.4/32

Once you've set up rules that allow you to access your cluster you are ready to
verify that you have got access.
