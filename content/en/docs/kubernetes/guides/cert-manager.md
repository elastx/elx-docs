---
title: "Cert-manager and Cloudflare demo"
description: "Using Cluster Issuer with cert-manager and wildcard DNS"
weight: 5
alwaysopen: true
---

In this guide we will use a Cloudflare managed domain and a our own cert-manager to provide LetsEncrypt certificates for a test deployment.

The guide is suitable if you have a domain connected to a single cluster, and would like a to issue/manage certificates from within kubernetes. The setup below becomes Clusterwider, meaning it will deploy certificates to any namespace specifed.


### Prerequisites

* DNS managed on Cloudflare
* Cloudflare API token
* Installed cert-manager. [See our guide here](../install-certmanager/).
* Installed IngressController. [See our guide here](../install-ingress/).

### Setup ClusterIssuer

Create a file to hold the secret of your _api token_ for your Cloudflare DNS. Then create the `ClusterIssuer` configuration file adapted for Cloudflare. 

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token
  namespace: cert-manager
type: Opaque
stringData:
  api-token: "<your api token>"
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: cloudflare-issuer
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: <your email>
    privateKeySecretRef:
      name: cloudflare-issuer-key
    solvers:
    - dns01:
        cloudflare:
          email: <your email>
          apiTokenSecretRef:
            name: cloudflare-api-token
            key: api-token
```
```code
kubectl apply -f cloudflare-issuer.yml
```

The clusterIssuer is soon ready. Example output:

```code
kubectl get clusterissuers.cert-manager.io 
NAME                READY   AGE
cloudflare-issuer   True    6d18h
```

### Expose a workload and secure with Let's encrypt certificate

In this section we will setup a deployment, with it's accompanying service and ingress object. The ingress object will request a certificate for test2.domain.ltd, and once fully up and running, should provide https://test2.domain.ltd with a valid letsencrypt certificate.

We'll use the created `ClusterIssuer` and let cert-manager request new certificates for any added ingress object. This setup requires the "*" record setup in the DNS provider.

This is how the DNS is setup in this particular example:
A `A record` ("domain.ltd") points to the loadbalancer IP of the cluster.
A `CNAME record` refers to ("*") and points to the `A record` above. 

This example also specifies the `namespace` "echo2". 

```workload2.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo2-dep
  namespace: echo2
spec:
  selector:
    matchLabels:
      app: echo2
  replicas: 1
  template:
    metadata:
      labels:
        app: echo2
    spec:
      containers:
      - name: echo2
        image: hashicorp/http-echo
        args:
        - "-text=echo2"
        ports:
        - containerPort: 5678
      securityContext:
        runAsUser: 1001
        fsGroup: 1001
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: echo2
  name: echo2-service
  namespace: echo2
spec:
  ports:
    - protocol: TCP
      port: 5678
      targetPort: 5678
  selector:
    app: echo2
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo2-ingress
  namespace: echo2
  annotations:
    cert-manager.io/cluster-issuer: cloudflare-issuer
    kubernetes.io/ingress.class: "nginx"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - test2.domain.ltd
    secretName: test2-domain-tls
  rules:
  - host: test2.domain.ltd
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: echo5-service
            port:
              number: 5678
```


The DNS challenge and certificate issue process takes a couple of minutes. You can follow the progress by watching:

```bash
kubectl events -n cert-manager
```

Once completed, it shall all be accessible at http://test2.domain.ltd