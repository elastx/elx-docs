---
title: "Install and upgrade cert-manager"
description: "A guide showing you how to install and upgrade cert-manager"
weight: 5
alwaysopen: true
---

## Prereqs

If you have a namespace named `elx-cert-manager` you first need to remove some resources.

```bash
kubectl -n elx-cert-manager delete svc cert-manager cert-manager-webhook
kubectl -n elx-cert-manager delete deployments.apps cert-manager cert-manager-cainjector cert-manager-webhook
kubectl delete namespace elx-cert-manager
```

## Install

To install cert-manager run
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml
```

This will install cert-manager in the `cert-manager` namespace.

To verify the installation is easily done with cmctl (cert-manager CLI https://cert-manager.io/docs/reference/cmctl/#installation)
```bash
cmctl check api
```

If everything is working you should get this message `The cert-manager API is ready`

You can also verify it manually following this guide (https://cert-manager.io/docs/installation/verify/#manual-verification)