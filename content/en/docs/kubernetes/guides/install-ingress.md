---
title: "Install and upgrade ingress-nginx"
description: "A guide showing you how to install and upgrade ingress-nginx"
weight: 5
alwaysopen: true
---

We will base this guide on ingress-nginx [that can be found here](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx)

## Prereqs

1. Add helm repo

    ```bash
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    ```

2. Make sure to update repo cache

    ```bash
    helm repo update
    ```

## Install ingress-nginx

1. We have used tis values file:

    In this example we will store this file as values.yaml
    > **Note:** For a complete set of options see the [upstream documentation here](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx#values)
  
     ```yaml
     controller:
       kind: DaemonSet
       metrics:
         enabled: true
       service:
         enabled: true
       ingressClassResource:
         default: true
       publishService:
         enabled: false  
     defaultBackend:
       enabled: true
     ```

2. Install ingress

    ```bash
    helm install ingress-nginx ingress-nginx/ingress-nginx --values values.yaml --namespace ingress-nginx --create-namespace
    ```
  
    Example output:
  
    ```log
    NAME: ingress-nginx
    LAST DEPLOYED: Tue Jul 18 11:26:17 2023
    NAMESPACE: default
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    NOTES:
    The ingress-nginx controller has been installed.
    It may take a few minutes for the LoadBalancer IP to become available.
    You can watch the status by running 'kubectl --namespace default get services -o wide -w ingress-nginx-controller'
    [..]
    ```

## Upgrade ingress

If your ingress controller is running in the namespace `elx-ingress-nginx` (this was default behavior for clusters created prior to Kubernetes 1.26) change the namespace flag to ` elx-ingress-nginx `.

1. Run the upgrade
  
    ```bash
    helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --values values.yaml --namespace ingress-nginx
    ```
    Example output:
  
    ```log
    Release "ingress-nginx" has been upgraded. Happy Helming!
    NAME: ingress-nginx
    LAST DEPLOYED: Tue Jul 18 11:29:41 2023
    NAMESPACE: default
    STATUS: deployed
    REVISION: 2
    TEST SUITE: None
    NOTES:
    The ingress-nginx controller has been installed.
    It may take a few minutes for the LoadBalancer IP to be available.
    You can watch the status by running 'kubectl --namespace default get services -o wide -w ingress-nginx-controller'
    [..]
    ```
