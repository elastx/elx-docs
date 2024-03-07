---
title: "Install and upgrade ingress-nginx"
description: "A guide showing you how to install, upgrade and remove ingress-nginx."
weight: 5
alwaysopen: true
---
Starting at Kubernetes version v1.26, our default configured clusters are delivered without ingress.

This guide will assist you get a working up to date ingress controller and provide instructions for how to upgrade and delete it. Running your own is useful if you want to have full control.

The guide is based on on ingress-nginx Helm chart, [found here](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx).

### Prerequisites

1. Setup helm repo

    ```bash
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    ```

2. Make sure to update repo cache

    ```bash
    helm repo update
    ```

### Install ingress-nginx
We provide two main scenarios of how clients connect to the cluster. The configuration file, `values.yaml`, must reflect the correct scenario. For a complete set of options see the [upstream documentation here](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx#values).


>**NOTE**: Whitelisting IPs is achieved by specifying `loadBalancerSourceRanges` (see below).

       
1. Provide the correct configuration file for your scenario
    
      **Customer connects directly to the Ingress:**
  
     ```yaml
      controller:
        kind: DaemonSet
        metrics:
          enabled: true
        service:
          enabled: true
          annotations:
            loadbalancer.openstack.org/proxy-protocol: "true"
        ingressClassResource:
          default: true
        publishService:
          enabled: false  
        config:
          use-proxy-protocol: "true"
      defaultBackend:
        enabled: true
     ```


      **Customer connects via Proxy:**

     ```yaml
      controller:
        kind: DaemonSet
        metrics:
          enabled: true
        service:
          enabled: true
          #loadBalancerSourceRanges:
          #  - <Proxy(s)-CIDR>
        ingressClassResource:
          default: true
        publishService:
          enabled: false  
        config:
          use-forwarded-headers: "true"
      defaultBackend:
        enabled: true
     ```


2. Install ingress-nginx using Helm

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
    It may take a few minutes for the Load Balancer IP to become available.
    You can watch the status by running 'kubectl --namespace default get services -o wide -w ingress-nginx-controller'
    [..]
    ```


### Upgrade ingress-nginx

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
    It may take a few minutes for the Load Balancer IP to be available.
    You can watch the status by running 'kubectl --namespace default get services -o wide -w ingress-nginx-controller'
    [..]
    ```

### Remove ingress-nginx
The best practice is to use the helm template method to remove the ingress. This allows for proper removal of lingering resources, then remove the namespace.
>**Note**:
    Avoid running multiple ingress controllers using the same `IngressClass`. <br>
    [See more information here](https://kubernetes.github.io/ingress-nginx/user-guide/multiple-ingress/). 

1. Run the delete command
    ```bash
    helm template ingress-nginx ingress-nginx/ingress-nginx --values values.yaml --namespace ingress-nginx | kubectl delete -f -
    ```

1. Remove the namespace if necessary
    ```bash
    kubectl delete namespace ingress-nginx
    ```