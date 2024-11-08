---
title: Load balancers
description: Using a load balancer to expose services in the cluster
weight: 5
alwaysopen: true
---

Load balancers in our Elastx Kubernetes CaaS service are provided by [OpenStack
Octavia](https://docs.openstack.org/octavia/wallaby/reference/introduction.html)
in collaboration with the [Kubernetes Cloud Provider
OpenStack](https://github.com/kubernetes/cloud-provider-openstack). This article
will introduce some of the basics of how to use services of *service* type
*LoadBalancer* to expose service using OpenStack Octavia load balancers. For
more advanced use cases you are encouraged to read the official documentation of
each project or contacting our support for assistance.

### A quick example

Exposing services using a *service* with type *LoadBalancer* will give you an
unique public IP backed by an OpenStack Octavia load balancer. This example will
take you through the steps for creating such a service.

### Create the resources

Create a file called `lb.yaml` with the following content:

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
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/name: echoserver
  name: echoserver
  annotations:
    loadbalancer.openstack.org/x-forwarded-for: "true"
    loadbalancer.openstack.org/flavor-id: 552c16d4-dcc1-473d-8683-65e37e094443
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

Then create the resources in the cluster by running:
`kubectl apply -f lb.yaml`

You can watch the load balancer being created by running:
`kubectl get svc`

This should output something like:

  ```code
  NAME         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
  echoserver   LoadBalancer   10.233.32.83   <pending>     80:30838/TCP   6s
  kubernetes   ClusterIP      10.233.0.1     <none>        443/TCP        10h
  ```

The _<pending>_ output in the *EXTERNAL-IP* column tells us that the load
balancer has not yet been completely created.

We can investigate further by running:
`kubectl describe svc echoserver`

Output should look something like this:

  ```code
  Name:                     echoserver
  Namespace:                default
  Labels:                   app.kubernetes.io/name=echoserver
  Annotations:              loadbalancer.openstack.org/x-forwarded-for: true
  Selector:                 app.kubernetes.io/name=echoserver
  Type:                     LoadBalancer
  IP Family Policy:         SingleStack
  IP Families:              IPv4
  IP:                       10.233.32.83
  IPs:                      10.233.32.83
  Port:                     <unset>  80/TCP
  TargetPort:               8080/TCP
  NodePort:                 <unset>  30838/TCP
  Endpoints:
  Session Affinity:         None
  External Traffic Policy:  Cluster
  Events:
    Type    Reason                Age   From                Message
    ----    ------                ----  ----                -------
    Normal  EnsuringLoadBalancer  115s  service-controller  Ensuring load balancer
  ```

Looking at the *Events* section near the bottom we can see that the Cloud
Controller has picked up the order and is provisioning a load balancer.

Running the same command again (`kubectl describe svc echoserver`) after waiting
some time should produce output like:

  ```code
  Name:                     echoserver
  Namespace:                default
  Labels:                   app.kubernetes.io/name=echoserver
  Annotations:              loadbalancer.openstack.org/x-forwarded-for: true
  Selector:                 app.kubernetes.io/name=echoserver
  Type:                     LoadBalancer
  IP Family Policy:         SingleStack
  IP Families:              IPv4
  IP:                       10.233.32.83
  IPs:                      10.233.32.83
  LoadBalancer Ingress:     91.197.41.223
  Port:                     <unset>  80/TCP
  TargetPort:               8080/TCP
  NodePort:                 <unset>  30838/TCP
  Endpoints:
  Session Affinity:         None
  External Traffic Policy:  Cluster
  Events:
    Type    Reason                Age    From                Message
    ----    ------                ----   ----                -------
    Normal  EnsuringLoadBalancer  8m52s  service-controller  Ensuring load balancer
    Normal  EnsuredLoadBalancer   6m43s  service-controller  Ensured load balancer
  ```

Again looking at the *Events* section we can tell that the Cloud Provider has
provisioned the load balancer for us (the *EnsuredLoadBalancer* event).
Furthermore we can see the public IP address associated with the service by
checking the *LoadBalancer Ingress*.

Finally to verify that the load balancer and service are operational run:
`curl http://<IP address from LoadBalancer Ingress>`

Your output should look something like:

  ```code
  Hostname: echoserver-84655f4656-sc4k6

  Pod Information:
          -no pod information available-

  Server values:
          server_version=nginx: 1.13.3 - lua: 10008

  Request Information:
          client_address=10.128.0.3
          method=GET
          real path=/
          query=
          request_version=1.1
          request_scheme=http
          request_uri=http://91.197.41.223:8080/

  Request Headers:
          accept=*/*
          host=91.197.41.223
          user-agent=curl/7.68.0
          x-forwarded-for=213.179.7.4

  Request Body:
          -no body in request-
  ```

Things to note:

* You do not need to modify security groups when exposing services using load
  balancers.
* The *client_address* is the address of the load balancer and not the client
  making the request, you can find the real client address in the
*x-forwarded-for* header.
* The *x-forwarded-for* header is provided by setting the
  `loadbalancer.openstack.org/x-forwarded-for: "true"` on the service. Read more
about available annotations in the *Advanced usage* section.

## Advanced usage

For more advanced use cases please refer to the documentation provided by each
project or contact our support:

* [Kubernetes Cloud Provider
  OpenStack](https://github.com/kubernetes/cloud-provider-openstack/blob/master/docs/openstack-cloud-controller-manager/expose-applications-using-loadbalancer-type-service.md#service-annotations)
* [OpenStack Octavia](https://docs.openstack.org/octavia/wallaby/user/index.html)

## Good to know

### Load balancers are billable resources

Adding services of type *LoadBalancer* will create load balancers in OpenStack, which is a billable resource and you will be charged for them.

### Loadbalancer statuses

Load balancers within OpenStack have two distinct statuses, which may cause confusion regarding their meanings:

* **Provisioning Status**: This status reflects the overall condition of the load balancer itself. If any issues arise with the load balancer, this status will indicate them. Should you encounter any problems with this status, please don't hesitate to contact Elastx support for assistance.
* **Operating Status**: This status indicates the health of the configured backends, typically referring to the nodes within your cluster, especially when health checks are enabled (which is the default setting). It's important to note that an operational status doesn't necessarily imply a problem, as it depends on your specific configuration. If a service is only exposed on a single node, for instance, this is to be expected since load balancers by default distribute traffic across all cluster nodes.

#### Provisioning status codes

| Code | Description|
|------|------------|
|ACTIVE|The entity was provisioned successfully|
|DELETED|The entity has been successfully deleted|
|ERROR|Provisioning failed|
|PENDING_CREATE|The entity is being created|
|PENDING_UPDATE|The entity is being updated|
|PENDING_DELETE|The entity is being deleted|

#### Operating status codes

| Code | Description|
|------|------------|
|ONLINE| - Entity is operating normally </br> - All pool members are healthy|
|DRAINING| The member is not accepting new connections |
|OFFLINE| Entity is administratively disabled |
|DEGRADED| One or more of the entity’s components are in ERROR |
|ERROR| -The entity has failed </br> - The member is failing it’s health monitoring checks </br> - All of the pool members are in ERROR|
|NO_MONITOR| No health monitor is configured for this entity and it’s status is unknown|

### High availability properties

OpenStack Octavia load balancers are placed in two of our three availability
zones. This is a limitation imposed by the OpenStack Octavia project.

### Reconfiguring using annotations

Reconfiguring the load balancers using annotations is not as dynamic and smooth
as one would hope. For now, to change the configuration of a load balancer the
service needs to be deleted and a new one created.

### Loadbalancer protocols

Loadbalancers have support for multiple protocols. In general we would recommend everyone to try avoiding http and https simply because they do not perform as well as other protocols.

Instead use tcp or haproxys proxy protocol and run an ingress controller thats responsible for proxying within clusters and TLS.

### Load Balancer Flavors

Load balancers come in multiple flavors. The biggest difference is how much traffic they can handle. If no flavor is deployed, we default to `v1-lb-1`. However, this flavor can only push around 200 Mbit/s. For customers wanting to push potentially more, we have a couple of flavors to choose from:

| ID                                   | Name    | Specs     | Approx Traffic |
| ------------------------------------ | ------- | --------- | ---------------|
| 16cce6f9-9120-4199-8f0a-8a76c21a8536 | v1-lb-1 | 1G, 1 CPU | 200 Mbit/s     |
| 48ba211c-20f1-4098-9216-d28f3716a305 | v1-lb-2 | 1G, 2 CPU | 400 Mbit/s     |
| b4a85cd7-abe0-41aa-9928-d15b69770fd4 | v1-lb-4 | 2G, 4 CPU | 800 Mbit/s     |
| 1161b39a-a947-4af4-9bda-73b341e1ef47 | v1-lb-8 | 4G, 8 CPU | 1600 Mbit/s    |

To select a flavor for your Load Balancer, add the following to the Kubernetes Service `.metadata.annotations`:

```yaml
loadbalancer.openstack.org/flavor-id: <id-of-your-flavor>
```

Note that this is a destructive operation when modifying an existing Service; it will remove the current Load Balancer and create a new one (with a new public IP).

Full example configuration for a basic `LoadBalancer` service:

```yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    loadbalancer.openstack.org/flavor-id: b4a85cd7-abe0-41aa-9928-d15b69770fd4
  name: my-loadbalancer
spec:
  ports:
  - name: http-80
    port: 80
    protocol: TCP
    targetPort: http
  selector:
    app: my-application
  type: LoadBalancer
```
