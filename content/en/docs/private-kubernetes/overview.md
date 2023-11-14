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
  There's also support for having your storage encrypted thanks to our Fortanix HSM and KSM solution.

* **Auto scaling**: Strarting in private Kubernetes 2.0 we offer node autoscaling. Autoscaling works by checking the resources your workload is requesting. Autoscaling can help you scale your clusters in case you need to run jobs or when yur application scales out due to more traffic or users than normal.

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

Trial clusters follow the standard configuration. The only distinct difference is the time limited discount in price.

## Good to know

### Persistent volumes

Cross availability zone mounting of volumes is not supported. Therefore, volumes
can only be mounted by nodes in the same availability zone. 

### Cluster subnet CIDR

The default cluster node network CIDR is _10.128.0.0/22_. An alternate CIDR can
be specified on cluster creation. Changing CIDR after creation requires
rebuilding the cluster.

### Ordering and scaling

Ordering and scaling of clusters is currently a manual process involving contact
with either our sales department or our support. This is a known limitation, but
may change in the future.

Since Elastx Private Kubernetes 2.0 we offer auto scaling of workload nodes. This is based on resource requests meaning it relies on setting realistc requests on your workload. Configuring auto-scaling options is currently a manual process involving contact with either our sales department or our support.

### Optional features

Prior to Kubernetes relase 1.26 we offered NGINX Ingress Controller and cert-manager as optional features.

If you have an Ingress or certmanager installed by Elastx prior to Kubernetes 1.26 you need to manually upgrade them starting from the Kubernetes 1.26 release. In order to do this you can follow the [instruction for ingress here:](../guides/install-ingress/) and [instructions for certmanager here](../guides/install-certmanager/)

If you are ordering a new Kubernetes cluster you need to install an ingress and certmanager on your own behalf. We have however created a guide on how to install Nginx Ingress Controller and cert-manager. We will also maintain upgrade instructions coming out with new relases over time. If you instead wish to use your own ingress contoller you can simply ignore this part.
