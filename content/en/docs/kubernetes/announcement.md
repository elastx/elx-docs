---
title: "Announcements"
description: "Announcement for Kubernetes CaaS"
weight: 1
alwaysopen: true
---

## 2023-12-08 Kubernetes CaaS updates including autoscaling
We are happy to announce our new Kubernetes CaaS lifecycle management with support for both worker node auto scaling and auto healing. We have reworked a great deal of the backend for the service which will speed up changes, allow you to run clusters in a more efficient way as well as being able to handle increased load without manual intervention.

All new clusters will automatically be deployed using our new backend. Existing clusters will need to be running Kubernetes 1.25 in order to be upgraded. We plan to contact all customers during Q1 2024 in order to plan this together with the Kubernetes 1.26 upgrade.

When upgrading, there are a few changes that need immediate action. Most notably the ingress will be migrated to a load balancer setup. We have information on all changes in more detail here: https://docs.elastx.cloud/docs/kubernetes/knowledge-base/migration-to-caasv2/

You can find information, specifications and pricing here, https://elastx.se/en/kubernetes/. 

Service documentation is available here, https://docs.elastx.cloud/docs/kubernetes/.

If you have any general questions or would like to sign-up please contact us at hello@elastx.se.

For any technical questions please register a support ticket at https://support.elastx.se.
