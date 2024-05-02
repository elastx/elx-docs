---
title: "Migration to Kubernetes CaaS v2"
description: "Everything you need to know and prepare prior to migrating your cluster to Kubernetes CaaS v2"
weight: 1
---
> ** Please note this document was updated 20240305.

This document will guide through all new changes introduced when migrating to our new kubernetes deployment backend. All customers with a Kubernetes cluster created on Kubernetes 1.25 and earlier are affected.

We have received, and acted upon, customer feedback since our main announcement 2023Q4.
We provide two additional paths to reach v1.26:

- We've reverted to continue providing Ingress/Certmanager.
- To assist with your transition we can offer you an additional cluster (v1.26 or latest version) up to 30 days at no extra charge.

![Show-Details](/img/kubernetes/capi-migration/flowchart_shorter_overview.png)

All customers will receive this information when we upgrade clusters to v1.26, which also includes the migration procedure. Make sure to carefully read through and understand the procedure and changes in order to avoid potential downtime during the upgrade.

**Pre-Upgrade Information:**

- The following overall steps are crucial for a seamless upgrade process:
  1. Date for the upgrade is agreed upon.
  2. For users of Elastx managed ingress opting to continue with our management services:
      - Elastx integrates a load balancer into the ingress service. The load balancer is assigned an external IP-address that will be used for all DNS records post-transition (do not point DNS to this IP at this point).
      - Date of the traffic transition to the load balancer is agreed upon.

- Important Note Before the Upgrade:
  - Customers are required to carefully read and comprehend all changes outlined in the [migration documentation](../migration-to-caasv2/) to avoid potential downtime or disruptions.
  - In case of any uncertainties or challenges completing the steps, please contact Elastx support. We are here to assist and can reschedule the upgrade to a more suitable date if needed.

**To facilitate a seamless traffic transition, we recommend the following best practices:**

- Utilize CNAMEs when configuring domain pointers for the ingress. This approach ensures that only one record needs updating, enhancing efficiency.
- Prior to implementing the change, verify that the CNAME record has a low Time-To-Live (TTL), with a duration of typically 1 minute, to promote rapid propagation.

**During the traffic transition:**

- All DNS records or proxies need to be updated to point towards the new loadbalancer
  - In order to make this change as seamless as possible. We recommend the customer to make use of CNAMEs when pointing domains towards the ingress. This would ensure only one record needs to be updated. Prior to the change make sure the CNAME record has a low TTL, usually 1 minute is good to ensure rapid propagation

**During the traffic transition:**

1. Elastx will meticulously update the ingress service configuration to align with your specific setup.
2. The customer is responsible for updating all DNS records or proxies to effectively direct traffic towards the newly implemented load balancer.

**During the Upgrade:**

- Elastx assumes all necessary pre-upgrade changes have been implemented unless notified otherwise.
- On the scheduled upgrade day, Elastx initiates the upgrade process at the agreed-upon time.
- Note: The Kubernetes API will be temporarily unavailable during the upgrade due to migration to a load balancer.
- Upgrade Procedure:
  - The upgrade involves replacing all nodes in your cluster twice.
  - Migration to the new cluster management backend system will occur during Kubernetes 1.25, followed by the cluster upgrade to Kubernetes 1.26.

**After Successful Upgrade:**

- Users are advised to download a new kubeconfig from the object store for continued access and management.

## Possibility to get a new cluster instead of migrating

To address the growing demand for new clusters rather than upgrades, customers currently running Kubernetes 1.25 (or earlier) can opt for a new Kubernetes cluster instead of migrating their existing one. The new cluster can be of version 1.26 or the latest available (1.29 at the moment). This new cluster is provided free of charge for an initial 30-day period, allowing you the flexibility to migrate your services at your own pace. However, if the migration extends beyond 30 days, please note that you will be billed for both clusters during the extended period. We understand the importance of a smooth transition, and our support team is available to assist you throughout the process.

## Ingress

We are updating the way clusters accept incoming traffic by transitioning from accepting traffic on each worker node to utilizing a load balancer. This upgrade, effective from Kubernetes 1.26 onwards, offers automatic addition and removal of worker nodes, providing enhanced fault management and a single IP address for DNS and/or WAF configuration.

Before upgrading to Kubernetes 1.26, a migration to the new Load Balancer is necessary.
See below a flowchart of the various configurations. In order to setup the components correctly we need to understand your configuration specifics. Please review your scenario:

![Show-Details](/img/kubernetes/capi-migration/flowchart_ingress2.png)

### Using Your Own Ingress

If you manage your own add-ons, you can continue doing so. Starting from Kubernetes 1.26, clusters will no longer have public IP addresses on all nodes by default. We strongly recommend implementing a load balancer in front of your ingress for improved fault tolerance, especially in handling issues better than web browsers.

### Elastx managed ingress

If you are using the Elastx managed ingress, additional details about your setup are required.

#### Proxy Deployed in Front of the Ingress (CDN, WAF, etc.)

If a proxy is deployed, provide information on the IP addresses used by your proxy. We rely on this information to trust the `x-forwarded-` headers. By default, connections that do not come from your proxy are blocked directly on the load balancer, enforcing clients to connect through your proxy.

#### Clients Connect Directly to Your Ingress

If clients connect directly to the ingress, we will redirect them to the new ingress. To maintain client source IPs, we utilize HAProxy proxy protocol in the load balancer. However, during the change, traffic will only be allowed to the load balancer for approximately 1-2 minutes. Please plan accordingly, as some connections may experience downtime during this transition.

## Floating IPs

Floating IPs (FIPs) are now available for customers who choose to opt in. As part of the upgrade to Kubernetes 1.26, floating IPs will be removed from nodes by default. Instead, Load Balancers will be employed to efficiently direct traffic to services within the cluster.

Please note that current floating IPs will be lost if customers do not opt in for this feature during the upgrade process.

Should you wish to continue utilizing Floating IPs or enable them in the future, simply inform us, and we'll ensure to assist you promptly.

A primary use case where Floating IPs prove invaluable is in retaining control over egress IP from the cluster. Without leveraging FIPs, egress traffic will be SNAT'ed via the hypervisor.

## Kubernetes API

We are removing floating IPs for all control-plane nodes. Instead, we use a Load Balancer in front of control-planes to ensure the traffic will be sent to an working control-plane node.

Whitelisting of access to the API server is now controlled in the loadbalancer in front of the API.
Currently, managing the IP-range whitelist requires a [support ticket here](https://support.elastx.se/hc/en-us).

## Node local DNS

During the Kubernetes 1.26 upgrade we stop using the nodelocaldns. However to ensure we does not break any existing clusters the service will remain installed.

All nodes being added to the cluster running Kubernetes 1.26 or later will not make use of nodelocaldns and pods being created on upgraded nodes will instead make use of the CoreDNS service located in kube-system.

This may affect customers that make use of network policies. If the policy only allows traffic to nodelocaldns, it is required to update the policy to also allow traffic from the CoreDNS service.

### Network policy to allow CoreDNS and NodeLocalDNS Cache

This example allows DNS traffic towards both NodeLocalDNS and CoreDNS. This policy is recommended for customers currently only allowing DNS traffic towards NodeLocalDNS and can be used in a "transition phase" prior to upgrading to Kubernetes 1.26.

  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: allow-dns-access
  spec:
    podSelector: {}
    egress:
      - ports:
          - protocol: UDP
            port: 53
          - protocol: TCP
            port: 53
        to:
          - ipBlock:
              cidr: 169.254.25.10/32
          - podSelector:
              matchLabels:
                k8s-app: kube-dns
    policyTypes:
      - Egress
  ```

### Network policy to allow CoreDNS

This example shows an example network policy that allows DNS traffic to CoreDNS. This can be used after the upgrade to Kubernetes 1.26

  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: allow-dns-access
  spec:
    podSelector: {}
    egress:
      - ports:
          - protocol: UDP
            port: 53
          - protocol: TCP
            port: 53
        to:
          - podSelector:
              matchLabels:
                k8s-app: kube-dns
    policyTypes:
      - Egress
  ```
