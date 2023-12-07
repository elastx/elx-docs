---
title: "Install and upgrade ingress-nginx"
description: "A guide showing you how to install and upgrade ingress-nginx"
weight: 5
alwaysopen: true
---

This guide will help you get a working up to date ingress manager. Either by upgrading an existing one, 


This guide assist in taking ownership over ingress. This is required when upgrading to 1.26. As clusters created on prior to 1.26 are delivered without ingress, this guide asissts in setting up ingress.

We will base this guide on ingress-nginx [that can be found here](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx)

## Prereqs

1. Setup helm repo

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

Scenario if the cluster has a WAF or other proxy in front of the loadbalancer.

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
        # watchIngressWithoutClass: true # Required for certain backwards compatibility.
        config:
          use-proxy-protocol: "true"
      defaultBackend:
        enabled: true
     ```


2. Install ingress using Helm

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



## Upgrade

This section helps with managing the ingress lifecycle. There are a few scenarios. If the customer would like to remove the elastx provided, there are instructions at the delete step. There are also instructions on how to upgrade the ingress.

### Upgrade ingress by customer

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


### Upgrade ingress installed by Elastx

1. Check diff changes:

  ```bash
  helm template ingress-nginx ingress-nginx/ingress-nginx --values values.yaml --namespace elx-ingress-nginx | kubectl diff -f -
  ```


2. Apply changes:

  ```bash
  helm template ingress-nginx ingress-nginx/ingress-nginx --values values.yaml --namespace elx-ingress-nginx | kubectl apply -f -
  ```



## Delete elastx provided elx-ingress-nginx

Avoid running multiple ingress controllers using the same `IngressClass`. (In case this is of interest here is [information on running multiple ingress controllers](https://kubernetes.github.io/ingress-nginx/user-guide/multiple-ingress/)). The best practice is to use the helm template method to remove the ingress. This allows for proper removal of lingering resources, before removing the namespace `elx-ingress-nginx`.

Here is how the Elastx provided ingress is uninstalled:

```bash
helm template ingress-nginx ingress-nginx/ingress-nginx --values values.yaml --namespace elx-ingress-nginx | kubectl delete -f -
```


## Security groups for clusters running kubernetes v1.25

We delivered our clusters inaccessible from the internet. To provide ingress
access you need to define rules allowing such traffic.

To do so, log into [Elastx OpenStack IaaS](https://ops.elastx.cloud/). Once logged
in click on the "Network" menu option in the left-hand side menu. Then click on
"Security Groups", finally click on the "Manage Rules" button to the right of
the security group named _cluster-name-worker-customer_. To add a rule click on
the "Add Rule" button.

To allow access from internet to the ingress controllers add the following rules:

  ```ini 
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
  ```