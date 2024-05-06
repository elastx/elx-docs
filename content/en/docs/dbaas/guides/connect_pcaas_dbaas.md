---
title: "Connect Kubernetes with DBaaS"
description: "Overview on what is needed to connect Kubernetes with DBaaS"
weight: 4
alwaysopen: true
---

## Overview
To be able to establish a connection between your Kubernetes cluster and DBaaS, you need to permit the external IP addresses of your worker nodes  in DBaaS UIs firewall.

Get your worker nodes external IP with the CLI tool kubectl: `kubectl get nodes -o wide`

```shell
NAME                                            STATUS   ROLES           AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
company-stage1-control-plane-1701435699-7s27c   Ready    control-plane   153d   v1.28.4   10.128.0.40    <none>        Ubuntu 22.04.3 LTS   5.15.0-88-generic   containerd://1.7.6
company-stage1-control-plane-1701435699-9spjg   Ready    control-plane   153d   v1.28.4   10.128.1.160   <none>        Ubuntu 22.04.3 LTS   5.15.0-88-generic   containerd://1.7.6
company-stage1-control-plane-1701435699-wm8pd   Ready    control-plane   153d   v1.28.4   10.128.3.13    <none>        Ubuntu 22.04.3 LTS   5.15.0-88-generic   containerd://1.7.6
company-stage1-worker-sto1-1701436487-dwr5f     Ready    <none>          153d   v1.28.4   10.128.3.227   1.2.3.5       Ubuntu 22.04.3 LTS   5.15.0-88-generic   containerd://1.7.6
company-stage1-worker-sto2-1701436613-d2wgw     Ready    <none>          153d   v1.28.4   10.128.2.180   1.2.3.6       Ubuntu 22.04.3 LTS   5.15.0-88-generic   containerd://1.7.6
company-stage1-worker-sto3-1701437761-4d9bl     Ready    <none>          153d   v1.28.4   10.128.0.134   1.2.3.7       Ubuntu 22.04.3 LTS   5.15.0-88-generic   containerd://1.7.6
```

Copy the external IP for each worker node, in this case the three nodes with the ROLE `<none>`.

>You should add all workers external IP and the reserved external IP address to the firewall.
>The reserved external IP is for future cluster upgrades. If you don't know the
>reserved external IP, you can always contact support and we will help you. 

In the DBaaS UI, go to Datastores -> Firewall -> Create trusted source,
Add the external IP with CIDR notation /32 for each IP address (E.g. `1.2.3.5/32`).
