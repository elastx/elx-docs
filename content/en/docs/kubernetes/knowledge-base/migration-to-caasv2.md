---
title: "Migration to Kubernetes CaaS v2"
description: "Everything you need to know and prepare prior to migrating your cluster to Kubernetes CaaS v2"
weight: 1
---

This document will guide through all new changes introduced when migrating to our new kubernetes deployment backend. All customers with a Kubernetes cluster created on Kubernetes 1.25 or earlier are affected.

There are a few changes listed below. Make sure to carefully read through and understand them in order to avoid potential downtime during the upgrade. All customers will receive this information when we upgrade clusters to v1.26, 
which also includes the migration procedure.

## Addons

We have chosen to stop providing a managed Ingress and Certmanager.

There are multiple reasons. Most notably that the ingress configuration often changes based on each customer's requirements. Over time, this has proven challenging to support and test every scenario our customers might face. We have also witnessed an increased interest among customers to run and manage thier own ingress controllers.

We will ensure ingress is working during and after the migration and will after the Kubernetes 1.26 upgrade is completed hand over the responsibility to the customer that can decide if they want to continue to run and update the deployments we have installed or simply install their own. We will provide helpful instructions to migrate from an elastx managed default solution, but the work is required to be performed by the customer to avoid downtime, come the upgrade date.

### Ingress

We are changing the way the cluster default accepts incoming traffic, from accepting traffic to each worker node, to the new solution where a Load Balancer service. The service will automatically be able to add and remove worker nodes. Another consequence is that the customer will have one IP address that needs to be configured on DNS and/or WAF.

In order to enable the customer to not suffer downtime during the upgrade and migration procedure, we will plan to patch the managed ingress to support a Load Balancer service. This allows the customer to change DNS/WAF configuration to point towards the Load Balancer prior to starting the upgrade, which grants the best upgrade/migration experience.

We will setup a Load Balancer that runs in TCP mode. The operation mode is backwards compatible and will not break any existing configurations however there are a few quirks that the customer need to be aware of. In case the end users connect directly to the Load Balancer (not setting x-forwarded-for in a proxy in front of the ingress) the ingress controller will report source IPs as being the Load Balancer service. This will break setups that filters traffic based on source IP.

There are two other options to mitigate this behavior that can be used.

1. Change the ingress and Load Balancer to make use of HAProxy proxy protocol. This will ensure that source IPs are preserved. However it requires all clients that send traffic to the ingress to make use of the proxy-protocol and will break backwards compatibility for sending traffic directly to nodes on port 80 and 443.
2. The customer can choose to install a separate ingress and migrate over the services one by one. The customer need to make sure the ingress of choice support ingress classes and does not make use of the ingress class "nginx" since it is already in use by the ingress we installed.

If you wish to continue make use of the ingress we installed we have created a guide to help you get started [Install and upgrade ingress-nginx](../install-ingress/)

### Certmanager

We stop managing Certmanager after the Kubernetes 1.26 upgrade is completed. There is no breaking changes however, the customer is expected to update Certmanager in the cluster going forward.

To assist you, we have created a guide that can be found here [Install and upgrade cert-manager](../install-certmanager/)

## Floating IPs

Floating IPs are currently not supported on our new Kubernetes platform. We are however actively working on adding support and are targeting to have it available early 2024. We will ask all customers if they make use of this feature and in such cases, we will schedule the upgrade when the feature is ready.

If the customer does not make use of floating IPs, in most cases they are used for external whitelisting we will remove the floating IPs from nodes entirely and instead rely on Load Balancers to send traffic to services running inside the cluster.

## Kubernetes API

We are removing floating IPs for all control-plane nodes. Instead, we use a Load Balancer in front of control-planes to ensure the traffic will be sent to an working control-plane node.

Currently we do not support whitelisting IPs that can access the API. However we expect to have this feature available during Q1 2024.

## Node local DNS

During the Kubernetes 1.26 upgrade we stop using the nodelocaldns. However to ensure we does not break any existing clusters the service will remain installed.

All nodes being added to the cluster running Kubernetes 1.26 or later will not make use of nodelocaldns and pods being created on upgraded nodes will instead make use of the CoreDNS service located in kube-system.

This may affect customers that make use of network policies. If the policy only allows traffic to nodelocaldns, it is required to update the policy to also allow traffic from the CoreDNS service.

### Network policy to allow CoreDNS and NodeLocalDNS Cache

This example allows DNS traffic towards both NodeLocalDNS and CoreDNS. This policy is recommended for customers currently only allowing DNS traffic towards NodeLocalDNS and can be used in a "transition phase" prior to upgrading to Kubernetes 1.26.

  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: allow-dns-access
  spec:
    podSelector: {}
    egress:
      - ports:
          - protocol: UDP
            port: 53
          - protocol: TCP
            port: 53
        to:
          - ipBlock:
              cidr: 169.254.25.10/32
          - podSelector:
              matchLabels:
                k8s-app: kube-dns
    policyTypes:
      - Egress
  ```

### Network policy to allow CoreDNS

This example shows an example network policy that allows DNS traffic to CoreDNS. This can be used after the upgrade to Kubernetes 1.26

  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: allow-dns-access
  spec:
    podSelector: {}
    egress:
      - ports:
          - protocol: UDP
            port: 53
          - protocol: TCP
            port: 53
        to:
          - podSelector:
              matchLabels:
                k8s-app: kube-dns
    policyTypes:
      - Egress
  ```
