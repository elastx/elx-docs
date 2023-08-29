---
title: "Loadbalancer flavors"
description: "Available flavors and how to use them"
weight: 1
---

For a general tutorial on how to get started with loadbalancers in Kubernetes, please see the [Getting Started docs](https://docs.elastx.cloud/docs/private-kubernetes/getting-started/loadbalancer/).

By default, loadbalancers are created with **1G RAM** and **1 CPU core**. For some use cases this will not be sufficient.

# LB provider

Most of our Kubernetes clusters are still configured with the legacy `octavia` provider, for new clusters we are making the successor to `octavia`: `amphora` - the default.

If you need more powerful loadbalancers than the default option mentioned above, we recommend using the `amphora` provider. To see which one you are currently using you can run the below in your cluster:

```shell
kubectl -n kube-system get secret external-openstack-cloud-config -o jsonpath='{.data.cloud\.conf}' | base64 -d - | grep lb-provider
```

To change lb-provider please create a support case.

# Available flavors

## lb-provider: amphora

| ID                                   | Name    | Specs     |
| ------------------------------------ | ------- | --------- |
| 16cce6f9-9120-4199-8f0a-8a76c21a8536 | v1-lb-1 | 1G, 1 CPU |
| 48ba211c-20f1-4098-9216-d28f3716a305 | v1-lb-2 | 1G, 2 CPU |
| b4a85cd7-abe0-41aa-9928-d15b69770fd4 | v1-lb-4 | 2G, 4 CPU |
| 1161b39a-a947-4af4-9bda-73b341e1ef47 | v1-lb-8 | 4G, 8 CPU |

## LEGACY lb-provider: octavia

| ID                                   | Name            | Specs     |
| ------------------------------------ | --------------- | --------- |
| 4fa90798-b194-4189-981a-4b4856b8e400 | v1-lb-4-octavia | 2G, 4 CPU |
| 0bdfc547-da62-4971-9f07-f6b5f46f5dd2 | v1-lb-8-octavia | 4G, 8 CPU |

# Using a flavor

To select a flavor for your loadbalancer, add the below to the Kubernetes Service `.metadata.annotations`:

```yaml
loadbalancer.openstack.org/flavor-id: <id-of-your-flavor>
```

Note that this is a destructive operation when modifying an existing Service, it will remove the current loadbalancer and create a new one (with a new public IP).
