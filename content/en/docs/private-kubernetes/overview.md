---
title: "Overview"
description: "Elastx Kubernetes CaaS"
weight: 1
alwaysopen: true
---

*Elastx Kubernetes CaaS* consists of a fully redundant Kubernetes cluster
spread over three separate physical locations (availability zones) in Stockholm,
Sweden. Managed and monitored by us 24x7. It even includes round-the-clock
support.

![Overview of Elastx Kubernetes CaaS data centers](/img/dc-1.png)

## Features

Elastx Kubernetes CaaS runs on top of our high perfomant OpenStack IaaS platform
and we integrate with the features it provides.

* **High availability**: Cluster nodes are spread over our three availability zones,
  combined with our great connectivity this creates a great platform for you to
  build highly available services on.

* **Load Balancer**: Services that use the type "LoadBalancer" in Kubernetes
  integrate with [OpenStack Octavia](https://docs.openstack.org/octavia/train/reference/introduction.html).
  Each service exposed this way gets its own public IP (*Floating IP* in OpenStack
  lingo).

* **Persistent Storage**: When creating a *Persistent Volume Claim* Kubernetes
  creates a volume using [OpenStack Cinder](https://docs.openstack.org/cinder/latest/)
  and then connects the volume on the node where your pod(s) gets scheduled.
  There's also support for having your storage encrypted thanks to our Fortanix
  [HSM and KMS solution for OpenStack](https://elastx.se/en/blog/check-out-our-customer-testimonial-for-fortanix-services).

* **Ingress Controller**: We combine [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
  with [cert-manager](https://cert-manager.io/docs/).
  Thereby allowing you to use Ingress resources to expose you services.
  *cert-manager* helps you automate the creation of Let's Encrypt SSL certificates.

* **Standards conformant**: Our clusters are certified by the [CNCF Conformance Program](https://www.cncf.io/certification/software-conformance/)
  ensuring interoperability with Cloud Native technologies and minimizing vendor lock-in.

## Standard configuration

The standard configuration consist of the following:

* Three control plane nodes, one in each of our availability zones. Flavor:
  v1-c2-m8-d80
* Three worker nodes, one in each of our availability zones. Flavor:
  v1-c2-m8-d80

This configuration is the minimal configuration offered, scaling up and out as
required is supported. Clusters using smaller flavors or fewer nodes are not
supported by Elastx Kubernetes CaaS.

### Trial clusters

Trial clusters can be ordered in whatever configuration you wish. Do note
however that trial cluster that do not meet at least the standard
configuration will have to be rebuilt to be turned in to production ready clusters.

## Good to know

### Optional features

The NGINX Ingress Controller and cert-manager are optional features, they are
however part of the default configuration. If you wish to manage those features
on your own please opt-out when ordering.

### Persistent volumes

Cross availability zone mounting of volumes is not supported. That is volumes
can only be mounted by nodes in the same availability zone. Take this in to
consideration with regards to high availability when ordering a cluster.

### Cluster subnet CIDR

The default cluster node network CIDR is _10.128.0.0/22_. An alternate CIDR can
be specified on cluster creation. Changing CIDR after creation requires
rebuilding the cluster.

### Ordering and scaling

Ordering and scaling of clusters is currently a manual process involving contact
with either our sales department or our support. This is a known limitation, but
may change in the future.
