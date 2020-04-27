---
title: A simple load balanced service
description: How to expose a service through a load balancer instead of the ingress controller
weight: 4
alwaysopen: true
---

Exposing services with a *service* with type *LoadBalancer* will give you an unique public IP for that specific service. We will do the following:

* Create a *namespace* called `my-lb-service`
* Create a *deployment* that runs multiple *serve_hostname* pods
* Create a *service* with type LoadBalancer

## Create and apply manifests

Copy and save this to a file called `namespace-my-lb-service.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: my-lb-service
```

Copy and save this to a file called `deployment-my-lb-service.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: my-lb-service-server_hostname
  name: my-lb-service-servehostname
  namespace: my-lb-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-lb-service-servehostname
  template:
    metadata:
      labels:
        app: my-lb-service-servehostname
    spec:
      securityContext:
        runAsUser: 1001
        fsGroup: 1001
      containers:
      - image: k8s.gcr.io/serve_hostname
        name: servehostname
```

Copy and save this to a file called `service-my-lb-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: my-lb-service-servehostname
  name: my-lb-service-servehostname
  namespace: my-lb-service
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 9376
  selector:
    app: my-lb-service-servehostname
  type: LoadBalancer
```

And if you haven't already, run `kubectl create -f <manifest>.yaml` on each manifest.

You should now have a service that is load balanced. Check your external IP and visit it on port 80:

```bash
$ kubectl -n my-lb-service get svc
NAME                  TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)        AGE
my-lb-service-nginx   LoadBalancer   10.233.37.187   212.237.149.x     80:32642/TCP   1m
```

Doing multiple `curl 212.237.149.x` will give replies with different hostname of the pod you happen to access. These should vary with 3 different hostnames.
