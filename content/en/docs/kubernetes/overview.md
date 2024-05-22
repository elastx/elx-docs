---
title: "Overview"
description: "Elastx Kubernetes CaaS"
weight: 1
alwaysopen: true
---

*Elastx Kubernetes CaaS* consists of a fully redundant Kubernetes cluster
spread over three separate physical locations (availability zones) in Stockholm,
Sweden. We offer managed addons and monitoring 24x7, including support.

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

* **Auto scaling**: Starting in CaaS 2.0 we offer node autoscaling. Autoscaling works by checking the resources your workload is requesting. Autoscaling can help you scale your clusters in case you need to run jobs or when yur application scales out due to more traffic or users than normal.

* **Standards conformant**: Our clusters are certified by the [CNCF Conformance Program](https://www.cncf.io/certification/software-conformance/)
  ensuring interoperability with Cloud Native technologies and minimizing vendor lock-in.

## Flavor of nodes

The standard configuration consist of the following:

* Three control plane nodes, one in each of our availability zones. Flavor:
  v1-c2-m8-d80
* Three worker nodes, one in each of our availability zones. Flavor:
  v1-c2-m8-d80

### Minimal configuration

* Three control plane nodes, one in each of our availability zones. Flavor:
  v1-c2-m8-d80
* One worker node, Flavor:
  v1-c2-m8-d80

  This is the minimal configuration offered. Scaling to larger flavors and adding nodes are supported. Autoscaling is not supported with a single worker node.

> **Note:**
SLA is different for minimal configuration type of cluster. SLA's can be found [here](https://elastx.se/en/kubernetes/sla).

## Good to know

### Design your Cloud

We expect customers to design their setup to not require access to Openstack Horizon. This is to future proof the product.
This means, do not place other instances in the same Openstack project, nor utilize Swift (objectstore) in the same project.
We are happy to provide a separate Swiftproject, and a secondary Openstack project for all needs. We do not charge per each Openstack project!

### Persistent volumes

Cross availability zone mounting of volumes is not supported. Therefore, volumes
can only be mounted by nodes in the same availability zone.

### Cluster subnet CIDR

The default cluster node network CIDR is *10.128.0.0/22*. An alternate CIDR can
be specified on cluster creation. Changing CIDR after creation requires
rebuilding the cluster.

### Worker nodes Floating IPs

By default, our clusters come with nodes that do not have any Floating IPs attached to them. If, for any reason, you require Floating IPs on your workload nodes, please inform us, and we can configure your cluster accordingly. It's worth noting that the most common use case for Floating IPs is to ensure predictable source IPs. However, please note that enabling or disabling Floating IPs will necessitate the recreation of all your nodes, one by one.

### Ordering and scaling

Ordering and scaling of clusters is currently a manual process involving contact
with either our sales department or our support. This is a known limitation, but we are quick to respond and a cluster is typically delivered within a business day.

Since Elastx Private Kubernetes 2.0 we offer auto scaling of workload nodes. This is based on resource requests, which means it relies on the administator to set realistic requests on the workload. Configuring auto-scaling options is currently a manual process involving contact with either our sales department or our support.

### Optional features and add-ons

We offer a managed cert-manager and a managed NGINX Ingress Controller.

If you are interested in removing any limitations, we've assembled guides with everything you need to install the same IngressController and cert-manager as we provide. This will give you full control. The various resources gives configuration examples, and instructions for lifecycle management. These can be found in the sections [Getting Started](../getting-started/) and [Guides](../guides/).
