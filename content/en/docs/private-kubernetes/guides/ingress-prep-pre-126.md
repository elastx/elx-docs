---
title: "Ingress configuration for Kubernetes 1.25 and earlier"
description: "For clusters created prior to Kubernetes 1.25 some additional configuration is needed to get started with the bundled ingress-nginx controller"
weight: 5
alwaysopen: true
---

> **Note:** This guide is only for clusters created prior to Kubernetes 1.26.

# Preparation and information steps for clusters created prior to Kubernetes 1.26

We run ingress controllers as daemonsets on each of the worker nodes. Providing a
cheap and easy way to let traffic in to your cluster. To enable traffic to
reach your worker nodes you need to add rules to the security groups governing
access to those nodes.

## Security groups

We deliver our clusters inaccessible from the internet. To provide ingress
access you need to define rules allowing such traffic.

To do so, log into [Elastx OpenStack IaaS](https://ops.elastx.cloud/). Once logged
in click on the "Network" menu option in the left-hand side menu. Then click on
"Security Groups", finally click on the "Manage Rules" button to the right of
the security group named _cluster-name-worker-customer_. To add a rule click on
the "Add Rule" button.

To allow access from internet to the ingress controllers add the following rules:

    Rule: Custom TCP Rule
    Direction: Ingress
    Open Port: Port
    Port: 80
    Remote: CIDR
    CIDR: 0.0.0.0/0

    Rule: Custom TCP Rule
    Direction: Ingress
    Open Port: Port
    Port: 443
    Remote: CIDR
    CIDR: 0.0.0.0/0
