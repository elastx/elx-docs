---
title: Persistent volumes
description: Using persistent volumes
weight: 3
alwaysopen: true
---

Persistent volumes in our Elastx Kubernetes CaaS service are provided by [OpenStack
Cinder](https://docs.openstack.org/cinder/ussuri/). Volumes are dynamically
provisioned by [Kubernetes Cloud Provider
OpenStack](https://github.com/kubernetes/cloud-provider-openstack/).

## Storage classes

`8k` refers to 8000 IOPS.

> See our [pricing page](https://elastx.se/en/openstack/pricing)  under the table *Storage* to calculate your costs.

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

### Limit of 25 volumes per node (clusters prior to v1.26)

There is a hard limitation of 25 volumes per node, including root volume. In case >20 volumes are required per node, consider adding additional worker nodes.

### Encryption

All volumes are encrypted at rest in hardware.

### Volume type `hostPath`
A volume of type hostPath is in reality just a local directory on the specific node being mounted in a pod, this means data is stored locally and will be unavailable if the pod is ever rescheduled on another node. This is expected during cluster upgrades or maintenance, however it may also occur because of other reasons, for example if a pod crashes or a node is malfunctioning. <br />
You can read more about this [here](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath). <br />
If you are looking for a way to store persistent data we would instead recommend to make use of PVCs. PVCs can move between nodes within one data-center meaning any data stored will be present even if the pod is being recreated.

## Known issues

### Resizing encrypted volumes

Legacy: encrypted volumes do not resize properly, please contact our support if you wish
to resize such a volume.
