---
title: "Certmanager "
description: "Full example to setup Cert manager"
weight: 5
alwaysopen: true
---


cert-manager is a powerful X.509 certificate controller for Kubernetes.
It will obtain certificates from a variety of Issuers and ensure the certificates are valid and up-to-date, and will attempt to renew certificates at a configured time before expiry.

In this guide we will make use of a Cloudflare managed DNS, and a cert-manager like in [our guide](../install-certmanager) to setup LetsEncrypt certificate on a test deployment.


### Prerequisites
* DNS entry on Cloudflare pointing to LoadBalancer IP
* Cloudflare API token
* Installed cert-manager
* Installed IngressController [nginx guide here](../install-ingress)

### Setup ClusterIssuer
Create a file to hold the secret of your api token for your Cloudflare DNS, and the ClusterIssuer configuration adapted for Cloudflare.

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

The clusterIssuer is now ready. Example output:

```code
k get clusterissuers.cert-manager.io 
NAME                READY   AGE
cloudflare-issuer   True    6d18h
```


### Expose a workload using a DNSprovider managed DNS

Let's setup a workload, and expose it via the ingress controller. In this example we will use a DNS record (test1.domain.ltd) that we manage at the DNS provider.

The DNS setup is as follows:
An `A record` ("test1.domain.ltd") points to the loadbalancer IP of the cluster.


```workload1.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo1-dep
spec:
  selector:
    matchLabels:
      app: echo1
  replicas: 1
  template:
    metadata:
      labels:
        app: echo1
    spec:
      containers:
      - name: echo1
        image: hashicorp/http-echo
        args:
        - "-text=echo1"
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
    app: echo1
  name: echo1-service
spec:
  ports:
    - protocol: TCP
      port: 5678
      targetPort: 5678
  selector:
    app: echo1
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo1-ingress
  annotations:
    cert-manager.io/cluster-issuer: cloudflare-issuer
    kubernetes.io/ingress.class: "nginx"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - test1.domain.ltd
    secretName: test1-domain-tls
  rules:
  - host: test1.domain.ltd
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        #pathType: Prefix
        backend:
          service:
            name: echo1-service
            port:
              number: 5678
```


### Expose a workload using wildcard DNS managed by cert-manager

In the following example, we'll use the same `ClusterIssuer` but let cert-manager issue new certificates for any added ingress object.
This setup requires a different setup in the DNS provider, notably the "*" record. 

This is how the DNS is setup in this particular example:
A `A record` ("domain.ltd") points to the loadbalancer IP of the cluster.
A `CNAME record` refers to ("*") and points to the `A record` above. 

This example also makes use of its own `namespace` called "echo2". 

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


k events -w -n echo5