---
title: "Overview"
description: "Overview over ELASTX Private Kubernetes"
weight: 1
alwaysopen: true
---

*ELASTX Private Kubernetes* consists of a fully redundant cluster spread over three different physical locations in Stockholm, Sweden. Managed and monitored by us 24x7. You also have access to our support at any time.

If you run services in our OpenStack platform you can have workloads alongside your Kubernetes cluster.

![Overview of Private Kubernetes data centers](/img/dc-1.png)

When you schedule services, there are some things to be aware of in order to fully take advantage of the possibilities we provide. With that said, you can use all tooling that supports a standard setup of Kubernetes.

## Features

As Kubernetes runs on top of our high perfomant OpenStack platform, we integrate with the features it provides.

* Load Balancer: Services that use the type "LoadBalancer" in Kubernetes integrates with *OpenStack Octavia*. And each service exposed this way gets its own public IP (floating ip in OpenStack lingo).

* Persistent Storage: When creating a *volume claim* Kubernetes creates a volume using *OpenStack Cinder* and then connects the volume on the node where your pod(s) gets scheduled. There's also support for having your storage encrypted thanks to our Fortanix [HSM and KMS solution for OpenStack](https://elastx.se/en/blog/check-out-our-customer-testimonial-for-fortanix-services).

* Ingress Controller: We are combining *Nginx Ingress controller* with *Cert Manager*. So if you want, you can create an ingress to expose your web service. *Cert Manager* can help automate the creation of Let's Encrypt SSL certificates.
