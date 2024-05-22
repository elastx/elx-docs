---
title: "Install and upgrade cert-manager"
description: "A guide showing you how to install, upgrade and remove cert-manager"
weight: 5
alwaysopen: true
---

Starting at Kubernetes version v1.26, our default configured clusters are delivered without cert-manager.

This guide will assist you get a working up to date cert-manager and provide instructions for how to upgrade and delete it. Running your own is useful if you want to have full control.

The guide is based on cert-manager Helm chart, [found here](https://cert-manager.io/docs/installation/helm/). We draw advantage of the option to install CRDs with kubectl, as recommended for a production setup.

## Prerequisites
Helm needs to be provided with the correct repository:

1. Setup helm repo

    ```bash
    helm repo add jetstack https://charts.jetstack.io --force-update
    ```

1. Verify you do not have a namespace named `elx-cert-manager` as you first need to remove some resources.

    ```bash
    kubectl -n elx-cert-manager delete svc cert-manager cert-manager-webhook
    kubectl -n elx-cert-manager delete deployments.apps cert-manager cert-manager-cainjector cert-manager-webhook
    kubectl delete namespace elx-cert-manager
    ```

## Install

1. Prepare and install CRDs run:
    ```bash
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.crds.yaml
    ```

1. Run Helm install:
    ```bash
    helm install \
      cert-manager jetstack/cert-manager \
      --namespace cert-manager \
      --create-namespace \
      --version v1.14.4 \
    ``` 

    A full list of available Helm values is on [cert-manager's ArtifactHub page](https://artifacthub.io/packages/helm/cert-manager/cert-manager).

1. Verify the installation:
   Done with cmctl (cert-manager CLI https://cert-manager.io/docs/reference/cmctl/#installation).

    ```bash
    cmctl check api
    ```

    If everything is working you should get this message `The cert-manager API is ready`.


## Upgrade

The setup used above is referenced in the topic ["CRDs managed separately"](https://cert-manager.io/docs/installation/upgrade/#crds-managed-separately).

In these examples \<version> is "v1.14.4".

1. Update CRDS:

    ```bash
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/<version>/cert-manager.crds.yaml
    ```

1. Update the Helm chart:

    ```bash
    helm upgrade cert-manager jetstack/cert-manager --namespace cert-manager --version v1.14.4 
    ```

## Uninstall

To uninstall, use the guide [here](https://cert-manager.io/docs/installation/helm/#uninstalling).
