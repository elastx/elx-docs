---
title: "Ingress with Let's Encrypt"
description: "Example on using nginx ingress controller with cert manager"
weight: 5
alwaysopen: true
---

In this example we will expose a simple web service using Let's Encrypt certificates. We will do the following:

* Create a *namespace* called `my-web-service`
* Create an *Issuer* that configures *cert manager* for our namespace
* Create a *deployment* that runs multiple pods
* Create a *service* selecting pods from the above deployment
* Create an *ingress* that uses the *nginx ingress controller* and *cert manager*
* Create a *networkpolicy* that allows traffic from the nginx ingress to the acme-http-challenge pod *(optional)*

In our examples, all references the domain name `example.tld` needs to be changed to your own DNS record, which you point to the IP addresses given by us. We will use the *HTTP-01* challenge which means you need to do this before anything else.

> These examples are only to show how you get started with *Nginx Ingress Controller*, *Cert Manager* to get *Let's Encrypt* working.

## Create and apply manifests

After you saved each manifest, you should run `kubectl create -f <manifest>.yaml`.

Paste this yaml into `namespace-my-web-service.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: my-web-service
```

Now let's configure an *Issuer* that works inside this namespace. An *issuer* in cert manager helps sending a Certificate Signing Request (CSR) to an ACME server, in our example the ACME is Let's Encrypt boulder server. On its own, this does nothing. It acts on annotations `cert-manager.io/issuer: letsencrypt-prod` which we will see in the *ingress* manifest.

> Read more about how [Let's Encrypt works here!](https://letsencrypt.org/how-it-works/)

With modified email address, save this into `issuer-my-web-service.yaml`:

```yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-prod
  namespace: my-web-service
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

Our deployment manifest. It runs a simple serve_hostname container just presenting the hostname. Save this to `deployment-my-web-service.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: my-web-service
  name: my-web-service
  namespace: my-web-service
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
```

Our service, matching all pods from our deployment. Save this to `service-my-web-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: my-web-service
  name: my-web-service
  namespace: my-web-service
spec:
  ports:
  - port: 9376
    protocol: TCP
    targetPort: 9376
  selector:
    app: my-web-service
  type: ClusterIP
```

And last but not least our *ingress*. Save this to `ingress-my-web-service.yaml`:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: my-web-service-ingress
  namespace: my-web-service
  annotations:
    cert-manager.io/issuer: letsencrypt-prod
    kubernetes.io/ingress.class: "nginx"
spec:
  tls:
  - hosts:
    - example.tld
    secretName: example-tld
  rules:
  - host: example.tld
    http:
      paths:
      - path: /
        backend:
          serviceName: my-web-service
          servicePort: 9376
```

## Networkpolicies

If you are also using networkpolicies in the namespace you may need to add a networkpolicy that allows traffic from the ingress to the temporary pod that performs the HTTP challenge. 

If you are using the nginx-ingress we provide along with cert-manager it can look something like this, remember to change the namespace value in the metadata field to match the appropriate namespace. 

```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: letsencrypt-http-challenge
  namespace: my-web-service
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

## Final words

End result should be a web service printing out current pods hostname with SSL enabled and the certificate issued by Let's Encrypt:

![Let's Encrypt valid certificate](/img/examples/letsencrypt.png)

## See also

* [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* [NGINX Ingress Controller](https://github.com/kubernetes/ingress)
* [cert-manager](https://github.com/jetstack/cert-manager)
* [Let's Encrypt](https://letsencrypt.org/how-it-works/)
