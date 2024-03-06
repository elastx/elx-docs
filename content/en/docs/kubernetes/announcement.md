---
title: "Announcements"
description: "Announcement for Kubernetes CaaS"
weight: 1
alwaysopen: true
---

## 2024-03-08 Kubernetes v1.26 upgrade notice
To ECP customers that have not yet upgraded to v1.26, this announcement is valid for you.

We have received, and acted upon, customer feedback regarding the v1.26 upgrade.
Considering valuable feedback received from our customers, we are introducing two new options to ensure a suitable upgrade path for your cluster.

**Ingress and Certmanager**<br>
- We will not require customers to take ownership of the Ingress and Certmanager as advertised previously. We will continue to provide a managed Ingress/Certmanager.

**A new cluster free of charge**<br>
- You have the option to request a new cluster, in which you can setup your services at your own pace. You can choose the kubernetes version, we support 1.26 or 1.29 (soon 1.30). The cluster is free of charge for 30 days and after that, part of your standard environment. 
- We expect you to migrate your workloads from the old cluster to the new one, and then cancel the old cluster via a ZD ticket.

**What's next?**<br>
Our team will initiate contact via a Zendesk ticket to discuss your preferences and gather the necessary configuration options. We will initially propose a date and time for the upgrade.

Meanwhile, please have a look at our updated version of the migration guide to v1.26: <br> https://docs.elastx.cloud/docs/kubernetes/knowledge-base/migration-to-caasv2/.

In case you have any technical inquiries please submit a support ticket at: <br>
https://support.elastx.se. 

We are happy to help and guide you through the upgrade process.




## 2023-12-08 Kubernetes CaaS updates including autoscaling
We are happy to announce our new Kubernetes CaaS lifecycle management with support for both worker node auto scaling and auto healing. We have reworked a great deal of the backend for the service which will speed up changes, allow you to run clusters in a more efficient way as well as being able to handle increased load without manual intervention.

All new clusters will automatically be deployed using our new backend. Existing clusters will need to be running Kubernetes 1.25 in order to be upgraded. We plan to contact all customers during Q1 2024 in order to plan this together with the Kubernetes 1.26 upgrade.

When upgrading, there are a few changes that need immediate action. Most notably the ingress will be migrated to a load balancer setup. We have information on all changes in more detail here: https://docs.elastx.cloud/docs/kubernetes/knowledge-base/migration-to-caasv2/

You can find information, specifications and pricing here, https://elastx.se/en/kubernetes/. 

Service documentation is available here, https://docs.elastx.cloud/docs/kubernetes/.

If you have any general questions or would like to sign-up please contact us at hello@elastx.se.

For any technical questions please register a support ticket at https://support.elastx.se.
