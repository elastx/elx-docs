---
title: Persistent storage 
description: "What type of storage do we offer and an example on how to create a persistent volume claim"
weight: 3
alwaysopen: true
---

Here is a list of storage classes that can be used.

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

`4k` is short for 4000 IOPS and is the default storage class used when none is specified. Ending with `enc` is short for encrypted. Hence, 16kenc creates encrypted volumes suited for 16000 IOPS.

> See our [pricing page](https://elastx.se/en/pricing/)  under headline *Pricing ELASTX OpenStack IaaS* in the table *Storage* to calculate your costs.

A quick example to create an unused 1Gi volume claim named "example":

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
