---
title: "Ingress and cert-manager"
description: "Using Ingress resources to expose services"
weight: 5
alwaysopen: true
---

Our Kubernetes CaaS clusters by default include the [NGINX Ingress
Controller](https://kubernetes.github.io/ingress-nginx/) and
[cert-manager](https://cert-manager.io/docs/). It is possible to opt-out of
these if you wish to manage these functions on your own.

We run ingress controllers as daemonsets on each of the worker nodes. Providing a
cheap and easy way to let traffic in to your cluster. To enable traffic to
reach your worker nodes you need to add rules to the security groups governing
access to those nodes.

# Security groups

We deliver our clusters unaccessible from the internet, to provide ingress
access you need to define rules allowing such traffic.

To do so, log in to [Elastx Cloud](https://ops.elastx.cloud/). Once logged
in click on the "Network" menu option in the left-hand side menu. Then click on
"Security Groups", finally click on the "Manage Rules" button to the right of
the security group named _cluster-name-worker-customer_. To add a rule click on
the "Add Rule" button.

To allow access from internet to the ingress controllers add the following rules:

    Rule: Custom TCP Rule
    Direction: Ingress
    Open Port: Port
    Port: 80
    Remote: CIDR
    CIDR: 0.0.0.0/0

    Rule: Custom TCP Rule
    Direction: Ingress
    Open Port: Port
    Port: 443
    Remote: CIDR
    CIDR: 0.0.0.0/0

# A quick example

In this example we will expose a web service using an Ingress resource and
additionally demonstrate how to have cert-manager request a certificate to
enable TLS using Let's Encrypt.


## Prerequisites

* Security groups configured to allow traffic to worker nodes on port 80 and
  443 as described in the previous heading.
* A DNS record pointing at the public IP address of your worker nodes. In the
  examples all references to the domain _example.ltd_ must be replaced by the
  domain you wish to issue certificates for. Configuring DNS is out of scope for
this documentation.

## Create resources

Create a file called `ingress.yaml` with the following content:

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: my-web-service
  name: my-web-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-web-service
  template:
    metadata:
      labels:
        app: my-web-service
    spec:
      securityContext:
        runAsUser: 1001
        fsGroup: 1001
      containers:
      - image: k8s.gcr.io/serve_hostname
        name: servehostname
        ports:
        - containerPort: 9376
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: my-web-service
  name: my-web-service
spec:
  ports:
  - port: 9376
    protocol: TCP
    targetPort: 9376
  selector:
    app: my-web-service
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-web-service-ingress
  annotations:
    cert-manager.io/issuer: letsencrypt-prod
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - example.tld
    secretName: example-tld
  rules:
  - host: example.tld
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service
            name: my-web-service
            port:
              number: 9376
```
Then create the resources in the cluster by running:
`kubectl apply -f ingress.yaml`

Run `kubectl get ing` and you should see output similar to this:

    NAME                     CLASS   HOSTS         ADDRESS         PORTS     AGE
    my-web-service-ingress   nginx   example.tld   91.197.41.241   80, 443   39s

If not, wait a while and try again. Once you see output similar to the above you
should be able to reach your service at http://example.tld.


## Enabling TLS

A simple way to enable TLS for your service is by requesting a certificate using
the [Let's Encrypt CA](https://letsencrypt.org). This only requires a few simple
steps.

Begin by creating a file called `issuer.yaml` with the following content:

```yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # Let's Encrypt ACME server for production certificates
    server: https://acme-v02.api.letsencrypt.org/directory
    # This email address will get notifications if failure to renew certificates happens
    email: valid-email@example.tld
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

Replace the email address with your own. Then create the Issuer in the cluster
by running:
`kubectl apply -f issuer.yaml`

Next edit the file called `ingress.yaml` from the previous example and make sure
the *Ingress* resource matches the example below:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-web-service-ingress
  annotations:
    cert-manager.io/issuer: letsencrypt-prod
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - example.tld
    secretName: example-tld
  rules:
  - host: example.tld
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          serviceName: my-web-service
          servicePort: 9376
```

Make sure to replace all references to *example.tld* by your own domain. Then
update the resources by running:
`kubectl apply -f ingress.yaml`

Wait a couple of minutes and your service should be reachable at
https://example.tld with a valid certificate.

## Network policies

If you are using network policies you will need to add a networkpolicy that
allows traffic from the ingress controller to the temporary pod that performs
the HTTP challenge. With the default NGINX Ingress Controller provided by us
this policy should do the trick.

```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: letsencrypt-http-challenge
spec:
  policyTypes:
  - Ingress
  podSelector:
    matchLabels:
      acme.cert-manager.io/http01-solver: "true"
  ingress:
  - ports:
    - port: http
  - from:
    - namespaceSelector:
        matchLabels:
          app.kubernetes.io/name: ingress-nginx
```

# Advanced usage

For more advanced use cases please refer to the documentation provided by each
project or contact our support:

* [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* [NGINX Ingress Controller](https://github.com/kubernetes/ingress)
* [cert-manager](https://github.com/jetstack/cert-manager)
* [Let's Encrypt](https://letsencrypt.org/how-it-works/)
