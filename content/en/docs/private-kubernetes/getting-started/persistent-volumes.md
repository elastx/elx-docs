---
title: Persistent volumes 
description: Using persistent volumes
weight: 3
alwaysopen: true
---

Persistent volumes in our Elastx Kubernetes CaaS service are provided by [OpenStack
Cinder](https://docs.openstack.org/cinder/queens/). Volumes are dynamically
provisioned by [Kubernetes Cloud Provider
OpenStack](https://github.com/kubernetes/cloud-provider-openstack/).

# Storage classes

This is the current list of storage classes provided.

```bash
$ kubectl get storageclasses
NAME           PROVISIONER            AGE
16k            kubernetes.io/cinder   5d
16kenc         kubernetes.io/cinder   5d
4k (default)   kubernetes.io/cinder   5d
4kenc          kubernetes.io/cinder   5d
8k             kubernetes.io/cinder   5d
8kenc          kubernetes.io/cinder   5d
```

`4k` is short for 4000 IOPS and is the default storage class used when none is
specified. Classes ending with `enc` are encrypted by a per volume encryption
key. Hence, 16kenc creates encrypted volumes suited for 16000 IOPS.

> NOTE: The software encrypted volumes will soon be deprecated since all volume
> storage is already encrypted in hardware.

> See our [pricing page](https://elastx.se/en/pricing/)  under the heading *Pricing
> OpenStack* in the table *Storage* to calculate your costs.

# Example

A quick example of how to create an unused 1Gi persistent volume claim named
*example*:

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
name: example
spec:
accessModes:
- ReadWriteOnce
volumeMode: Filesystem
resources:
requests:
storage: 1Gi
storageClassName: 16k
```

```bash
$ kubectl get persistentvolumeclaim
NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
example   Bound    pvc-f8b1dc7f-db84-11e8-bda5-fa163e3803b4   1Gi        RWO            16k            18s
```

# Good to know
## Cross mounting of volumes

Cross mounting of volumes is not supported! That is a volume can only be mounted
by a node residing in the same availability zone as the volume. Plan
accordingly for ensured high availability!

## Encrypted volumes

All volumes are encrypted at rest in hardware. Volumes created by storage
classes ending with *enc* are also software encrypted using a per volume
encryption key. This provides increased security but has an impact on performance.

# Known issues

## Resizing encrypted volumes

Encrypted volumes do not resize properly, please contact our support if you wish
to resize such a volume.
