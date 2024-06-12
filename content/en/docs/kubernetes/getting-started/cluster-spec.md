---
title: "Cluster configuration"
description: "Cluster configuration and optional features"
weight: 1
alwaysopen: true
---

There are a lot of options possible for your cluster. Most options have a sane default however could be overridden on request.

A default cluster comes with 3 controlplane and 3 worker nodes. To connect all nodes we create a network, default (10.128.0.0/22). We also deploy monitoring to ensure functionality of all cluster components. However most things are just a default and could be overridden.

## Common options

### Nodes

The standard configuration consists of the following:

* Three control plane nodes, one in each of our availability zones. Flavor:
  v1-c2-m8-d80
* Three worker nodes, one in each of our availability zones. Flavor:
  v1-c2-m8-d80

#### Minimal configuration

* Three control plane nodes, one in each of our availability zones. Flavor:
  v1-c2-m8-d80
* One worker node, Flavor:
  v1-c2-m8-d80

  This is the minimal configuration offered. Scaling to larger flavors and adding nodes are supported. Autoscaling is not supported with a single worker node.

    > **Note:** SLA is different for minimal configuration type of cluster. SLA's can be found [here](https://elastx.se/en/kubernetes/sla).

### Nodegroups and multiple flavors

To try keep node management as easy as possible we make use of nodegroups. A nodegroup contains of one or multiple nodes with one flavor and a list of availability zones to deploy nodes in. Clusters are default deliverd with a nodegroup called `workers` containing 3 nodes one in each AZ. A nodegroup is limited to one flavor meaning all nodes in the nodegroup will have the same amount of CPU, RAM and disk.

You could have multiple nodegroups, if you for example want to target workload on separate nodes or in case you wish to consume multiple flavors.

A few examples of nodegroups:

| Name | Flavour | AZ list | Min node count | Max node count (autoscaling) |
| -------- | ----------------- | ------------- | ------------- | ------------- |
|worker |v1-c2-m8-d80 |STO1, STO2, STO3 |3 |0 |
|database |d2-c8-m120-d1.6k |STO1, STO2, STO3 |3 |0 |
|frontend |v1-c4-m16-d160 |STO1, STO2, STO3 |3 |12 |
|jobs |v1-c4-m16-d160 |STO1 |1 |3 |

In the examples we could see worker our default nodegroup and an example of having separate nodes for databases and frontend where the database is running on dedicated nodes and the frontend is running on smaller nodes but can autoscale between 3 and 12 nodes based on current cluster request. We also have a jobs nodegroup where we have one node in sto1 but can scale up to 3 nodes where all are placed inside STO1.
You can read more about [autoscaling here](../../guides/autoscaling/).

Nodegroups can be changed at any time. Please also note that we have auto-healing meaning in case any of your nodes for any reason stops working we will replace them. More about [autohealing could be found here](../../guides/autohealing/)

### Network

By default we create a cluster network  (10.128.0.0/22). However we could use another subnet per customer request. The most common scenario is when customer request another subnet is when exposing multiple Kubernetes clusters over a VPN.

Please make sure to inform us if you wish to use a custom subnet during the ordering process since we cannot replace the network after creation, meaning we would then need to recreate your entire cluster.

We currently only support cidr in the 10.0.0.0/8 subnet range and at least a /24. Both nodes and loadbalancers are using IPs for this range meaning you need to have a sizable network from the beginning.

### Cluster domain

We default all clusters to "cluster.local". This is simular to most other providers. If you wish to have another cluster domain please let us know during the ordering procedure since it cannot be replaced after cluster creation.

### Worker nodes Floating IPs

By default, our clusters come with nodes that do not have any Floating IPs attached to them. If, for any reason, you require Floating IPs on your workload nodes, please inform us, and we can configure your cluster accordingly. It's worth noting that the most common use case for Floating IPs is to ensure predictable source IPs. However, please note that enabling or disabling Floating IPs will necessitate the recreation of all your nodes, one by one but could be enabled or disabled at any time.

Since during upgrades we create a new node prior to removing an old node you would need to have an additional IP adress on standby. If you wish we to preallocate a list or range of IP adresses just mention this and we will configure your cluster accordingly.

Please know that only worker nodes are consume IP adresses meaning controlplane nodes does not make use of Floating IPs.

## Less common options

### OIDC

If you wish to integrate with your existing OIDC compatible IDP, example Microsoft AD And Google Workspace that is supported directy in the kubernetes api service.

By default we ship clusters with this option disabled however if you wish to make use of OIDC just let us know when order the cluster or afterwards. OIDC can be enabled, disabled or changed at any time.

## Cluster add-ons

We currently offer managed cert-manager, NGINX Ingress and elx-nodegroup-controller.

### Cert-manager

Cert-manager ([link to cert-manager.io](https://cert-manager.io/)) helps you to manage TLS certificates. A common use case is to use lets-encrypt to "automatically" generate certificates for web apps. However the functionality goes much deeper. We also have [usage instructions](../../guides/cert-manager/) and have a [guide](../../guides/install-certmanager/) if you wish to deploy cert-manager yourself.

### Ingress

An ingress controller in a Kubernetes cluster manages how external traffic reaches your services. It routes requests based on rules, handles load balancing, and can integrate with cert-manager to manage TLS certificates. This simplifies traffic handling and improves scalability and security compared to exposing each service individually. We have a usage guide with examples that can be found [here.](../../guides/ingress/)

We have chosen to use ingress-nginx and to support ingress, we limit what custom configurations can be made per cluster. We offer two "modes". One that we call direct mode, which is the default behavior. This mode is used when end-clients connect directly to your ingress. We also have a proxy mode for when a proxy (e.g., WAF) is used in front of your ingress. When running in proxy mode, we also have the ability to limit traffic from specific IP addresses, which we recommend doing for security reasons. If you are unsure which mode to use or how to handle IP whitelisting, just let us know and we will help you choose the best options for your use case.

If you are interested in removing any limitations, we've assembled guides with everything you need to install the same IngressController as we provide. This will give you full control. The various resources give configuration examples and instructions for lifecycle management. These can be found [here.](../../guides/install-ingress/)

### elx-nodegroup-controller

The nodegroup controller is useful when customers want to use custom taints or labels on their nodes. It supports matching nodes based on nodegroup or by name. The controller can be found on [Github](https://github.com/elastx/elx-nodegroup-controller) if you wish to inspect the code or deploy it yourself.
