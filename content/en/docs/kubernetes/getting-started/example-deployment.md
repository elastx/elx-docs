---
title: "Your first deployment"
description: "An example deployment to get started with your Kubernetes cluster"
weight: 3
alwaysopen: true
---

This page will help you getting a deployment up and running and exposed as a load balancer.

> **Note:** This guide is optional and only here to help new Kubernetes users with an example deployment.

Before following this guide you need to have [ordered a cluster](../ordering/) and followed the [Accessing your cluster guide](../accessing/)

You can verify access by running `kubectl get nodes` and if the output is similar to the example below you are set to go.

```bash
❯ kubectl get nodes
NAME                           STATUS   ROLES           AGE     VERSION
hux-lab1-control-plane-c9bmm   Ready    control-plane   2d18h   v1.27.3
hux-lab1-control-plane-j5p42   Ready    control-plane   2d18h   v1.27.3
hux-lab1-control-plane-wlwr8   Ready    control-plane   2d18h   v1.27.3
hux-lab1-worker-447sn          Ready    <none>          2d18h   v1.27.3
hux-lab1-worker-9ltbp          Ready    <none>          2d18h   v1.27.3
hux-lab1-worker-htfbp          Ready    <none>          15h     v1.27.3
hux-lab1-worker-k56hn          Ready    <none>          16h     v1.27.3
```

## Creating an example deployment

To get started we need a deployment to deploy.
Below we have a deployment called `echoserver` we can use for this example.

1. Start off by creating a file called `deployment.yaml` with the content of the deployment below:

    ```yaml
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app.kubernetes.io/name: echoserver
      name: echoserver
    spec:
      replicas: 3
      selector:
        matchLabels:
          app.kubernetes.io/name: echoserver
      template:
        metadata:
          labels:
            app.kubernetes.io/name: echoserver
        spec:
          containers:
          - image: gcr.io/google-containers/echoserver:1.10
            name: echoserver
    ```

2. After you have created your file we can apply the deployment by running the following command:

    ```bash
    ❯ kubectl apply -f deployment.yaml
    deployment.apps/echoserver created
    ```

3. After running the apply command we can verify that 3 pods have been created. This can take a few seconds.

    ```bash
    ❯ kubectl get pod
    NAME                          READY   STATUS    RESTARTS   AGE
    echoserver-545465d8dc-4bqqn   1/1     Running   0          51s
    echoserver-545465d8dc-g5xxr   1/1     Running   0          51s
    echoserver-545465d8dc-ghrj6   1/1     Running   0          51s
    ```

## Exposing our deployment

After your pods are created we need to make sure to expose our deployment. In this example we are creating a service of type loadbalancer. If you run this application in production you would likely install an [ingress controller](../../guides/install-ingress/)

1. First of we create a file called `service.yaml` with the content of the service below

    ```yaml
    ---
    apiVersion: v1
    kind: Service
    metadata:
      labels:
        app.kubernetes.io/name: echoserver
      name: echoserver
      annotations:
        loadbalancer.openstack.org/x-forwarded-for: "true"
    spec:
      ports:
      - port: 80
        protocol: TCP
        targetPort: 8080
        name: http
      selector:
        app.kubernetes.io/name: echoserver
      type: LoadBalancer
    ```

2. After creating the service.yaml file we apply it using kubectl

    ```bash
    ❯ kubectl apply -f service.yaml
    service/echoserver created
    ```

3. We should now be able to use our service by running `kubectl get service`

    ```bash
    ❯ kubectl get service
    NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
    echoserver   LoadBalancer   10.98.121.166   <pending>     80:31701/TCP   54s
    kubernetes   ClusterIP      10.96.0.1       <none>        443/TCP        2d20h
    ```

    For the echo service we can see that `EXTERNAL-IP` says `<pending>` this means that a load balancer is being created but is not yet ready. As soon as the load balancer is up and running we will instead use an IP address here we can use to access our application.

    Loadbalancers usually take around a minute to be created however can sometimes take a little longer.


4. Once the load balancer is up and running the `kubectl get service` should return something like this:

    ```bash
    ❯ kubectl get service
    NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
    echoserver   LoadBalancer   10.98.121.166   185.24.134.39   80:31701/TCP   2m24s
    kubernetes   ClusterIP      10.96.0.1       <none>          443/TCP        2d20h
    ```

## Access the example deployment

Now if we open our web browser and visits the IP address we should get a response looking something like this:

  ```code
  Hostname: echoserver-545465d8dc-ghrj6

  Pod Information:
    -no pod information available-

  Server values:
    server_version=nginx: 1.13.3 - lua: 10008

  Request Information:
    client_address=192.168.252.64
    method=GET
    real path=/
    query=
    request_version=1.1
    request_scheme=http
    request_uri=http://185.24.134.39:8080/

  Request Headers:
    accept=text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
    accept-encoding=gzip, deflate
    accept-language=en-US,en;q=0.9,sv;q=0.8
    host=185.24.134.39
    upgrade-insecure-requests=1
    user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36
    x-forwarded-for=90.230.66.18

  Request Body:
    -no body in request-
  ```

The Hostname shows which pod we reached and if we refresh the page we should be able to see this value change.

## Cleanup

To clean up everything we created you an run the following set of commands

1. We can start off by removing the deployment. To remove a deployment we can use kubectl delete and point it towards the file containing our deployment:

    ```bash
    ❯ kubectl delete -f deployment.yaml
    deployment.apps "echoserver" deleted
    ```

2. After our deployment are removed we can go ahead and remove our service and load balancer. Please note that this takes a few seconds since we are waiting for the load balancer to be removed.

    ```bash
    ❯ kubectl delete -f service.yaml
    service "echoserver" deleted
    ```
