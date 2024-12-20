---
title: "Install and upgrade ingress-nginx"
description: "A guide showing you how to install, upgrade and remove ingress-nginx."
weight: 5
alwaysopen: true
---

This guide will assist you get a working up to date ingress controller and provide instructions for how to upgrade and delete it. Running your own is useful if you want to have full control.

The guide is based on on ingress-nginx Helm chart, [found here](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx).

### Prerequisites
Helm needs to be provided with the correct repository:

1. Setup helm repo

    ```bash
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    ```

2. Make sure to update repo cache

    ```bash
    helm repo update
    ```

### Generate values.yaml
We provide settings for two main scenarios of how clients connect to the cluster. The configuration file, `values.yaml`, must reflect the correct scenario. 


*   **Customer connects directly to the Ingress:**
  
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
      allowSnippetAnnotations: true
      config:
        use-proxy-protocol: "true"
    defaultBackend:
      enabled: true
    ```


*  **Customer connects via Proxy:**

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
      allowSnippetAnnotations: true
      config:
        use-forwarded-headers: "true"
    defaultBackend:
      enabled: true
    ```

* **Other useful settings:**

  For a complete set of options see the [upstream documentation here](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx#values).

    ```yaml
      [...]
      service:
        loadBalancerSourceRanges:        # Whitelist source IPs.
          - 133.124.../32
          - 122.123.../24
        annotations:
          loadbalancer.openstack.org/keep-floatingip: "true"  # retain floating IP in floating IP pool.
          loadbalancer.openstack.org/flavor-id: "v1-lb-2"     # specify flavor.
      [...]
    ```


### Install ingress-nginx
Use the values.yaml generated in the [previous step](../install-ingress/#generate-valuesyaml).

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
  Use the values.yaml generated in the [previous step](../install-ingress/#generate-valuesyaml).


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
The best practice is to use the helm template method to remove the ingress. This allows for proper removal of lingering resources, then remove the namespace. Use the values.yaml generated in the [previous step](../install-ingress/#generate-valuesyaml).
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