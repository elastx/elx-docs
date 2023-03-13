---
title: Persistent volumes 
description: Using persistent volumes
weight: 3
alwaysopen: true
---

Persistent volumes in our Elastx Kubernetes CaaS service are provided by [OpenStack
Cinder](https://docs.openstack.org/cinder/train/). Volumes are dynamically
provisioned by [Kubernetes Cloud Provider
OpenStack](https://github.com/kubernetes/cloud-provider-openstack/).

## Storage classes 

`8k` refers to 8000 IOPS.

> See our [pricing page](https://elastx.se/en/openstack/pricing)  under the table *Storage* to calculate your costs.

### Kubernetes version < 1.22

This is the list of storage classes provided in clusters of version <1.22.

```bash
$ kubectl get storageclasses
NAME           PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
16k            cinder.csi.openstack.org   Delete          WaitForFirstConsumer   true                   167d
4k (default)   cinder.csi.openstack.org   Delete          WaitForFirstConsumer   true                   167d
8k             cinder.csi.openstack.org   Delete          WaitForFirstConsumer   true                   167d
```
### Kubernetes version > 1.23
This is the list of storage classes provided in clusters of version > 1.23.

```bash
$ kubectl get storageclasses
NAME                       PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
16k                        cinder.csi.openstack.org   Delete          WaitForFirstConsumer   true                   167d
8k                         cinder.csi.openstack.org   Delete          WaitForFirstConsumer   true                   167d
v1-dynamic-40 (default)    cinder.csi.openstack.org   Delete          WaitForFirstConsumer   true                   167d
```



### Example of PersistentVolumeClaim

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

## Good to know

### Cross mounting of volumes between nodes

Cross mounting of volumes is not supported! That is a volume can only be mounted
by a node residing in the same availability zone as the volume. Plan
accordingly for ensured high availability!

### Limit of 25 volumes per node

There is a hard limitation of 25 volumes per node, including root volume. In case >20 volumes are required per node, consider adding additional worker nodes.

### Encryption

All volumes are encrypted at rest in hardware.

## Known issues

### Resizing encrypted volumes

Legacy: encrypted volumes do not resize properly, please contact our support if you wish
to resize such a volume.
