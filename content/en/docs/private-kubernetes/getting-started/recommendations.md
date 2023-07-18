---
title: "Recommendations"
description: "An list of things we recommend to get the best experience from your Kubernetes cluster"
weight: 4
alwaysopen: true
---

This page describes a list of things that could help you get the best experience out of your cluster.

> **Note:** You do not need to follow this documentation in order to use your cluster

## Ingress and cert-manager

To make it easier to expose applications an ingress controller is commonly deployed.

An ingress controller makes sure when you go to a specific webpage you are routed towards the correct application.

There are a lot of different ingress controllers available. We on Elastx are using ingress-nginx and have a guide ready on how to get started. However you can deploy any ingress controller you wish inside your clusters.

To get a single IP-address you can point your DNS towards we recommend to deploy an ingress-controller with a service of type Load balancer. [More information regarding load balancers can be found here](#loadbalancers)

In order to automatically generate and update TLS certificates cert-manager is commonly deployed side by side with an ingress controller.

We have created a guide on how to get started with ingress-nginx and Cert-manager that can be found here: [Link to guide](../../guides/ingress/)

## Requests and limits

Below we describe requests and limits briefly. For a more detailed description or help setting requests and limits we recommend to check out Kubernetes documentation: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

### Requests

Requests and limits are just to help Kubernetes make better decisions when to schedule and limit your workload.

Requests are important for the scheduler. Requests can be seen as "Amount of resources the pod would utilize during normal operation". This means that the scheduler will allocate the required amount of resources and make sure they are always available to your pod.

Requests also helps the auto-scaler to make better decisions on when to scale a cluster up and down.
### Limits

Limits set the maximum allowed resource usage for a pod. This is important to avoid slowdowns in other pods running on the same node.

`CPU` limit. Your application will be throttled or simply run slower when trying to exceed the limit.
`Memory` limit is another beast. If any pod trying to use more memory than the limit the pod will be Out of memory killed.

## Autoscaling

Autoscaling can be done by scaling nodes and/or pods. To get the absolute best experience we recommend a combination of both.

## Scaling nodes

We have built in support for scaling nodes up and down. To get started with auto scaling we recommend that you check out our [guide that can be found here](../../guides/autoscaling/)

## Scaling pods

Kubernetes documentation have a guide on how to do this [that can be found here](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

In short, node autoscaling is only taken into consideration if you have any pods that cannot be scheduled or if you have set requests on your pods. In order to automatically scale an application pod scaling can make sure you get more pods before reaching your pod limit and if more nodes are needed in order to run the new pods nodes will automatically be added and then later removed when no longer needed.

## Network policies

Network policies can in short be seen as Kubernetes built in firewalls.

Network policy can be used to limit both incoming and outgoing traffic. This allows you for example to specify that only a set of your pods are allowed to talk to the database.

Kubernetes documentation have an excellent guide on how to get started with network policies [that can be found here](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

## Pod Security Standards / Pod Security Admission

Pod Security Admission can be used to limit what your pods can do. For example you can make sure pods are not allowed to run as root.

In order to get to know this more in detail and getting started we recommend to follow the Kubernetes documentation [that can be found here](https://kubernetes.io/docs/concepts/security/pod-security-admission/)

## Loadbalancers

Load balancers allow your application to be accessed from the internet. Load balancers can automatically split traffic to all your nodes to even out load. Load balancers can also detect if a node is having problems and remove it to avoid displaying errors to end users.

We have a guide on how to get started with load balancers [that can be found here](../../guides/loadbalancer/)
