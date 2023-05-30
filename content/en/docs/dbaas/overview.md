---
title: "Overview"
description: "Overview of DBaaS"
weight: 1
alwaysopen: true
---

Elastx DBaaS automatically ensures your databases are reliable, secure, and scalable so that your business continues to run without disruption. It provides full compatibility with the source database engines while reducing operations costs by automating database provisioning and other time-consuming tasks.
 
Easy high availability and disaster protection by configuring replication, clusters and backups to protect your data. Backups and multi-node datastores are disaster protected as they are running over multiple availability zones which in our case are geographically separated data centers. Automatic failover makes your database highly available. Your data is encrypted at rest, and ISO 27001, 27017, 27018 as well as 14001 compliant.

A Datastore is a database instance with one or more nodes. In the Datastore you can have one or more databases. A datastore can be created with a single node, three nodes in a active/active cluster or a primary node with one or two read only replicas.

You can manage the Datastores with the web-UI. Authentication to the web-UI is done with the Elastx Identity Provider where MFA with TOTP or Yubikey is required. All datastores owned by the organization will be visible for all users with access to that organization.

To access the datastores you need database user credentials which you get and manage for each individual database. You also need to configure the Datastore firewall to allow access from specific IP addresses. The Connection assistant will help you to get the connection string for common programming languages.

In the web-UI you get graphs on key performance metrics on the database and the nodes that will help you to manage capacity and performance. You can scale the Datastore by adding or removing nodes and also to change the size of a node by replacing a node with a different flavor. Contact Elastx support if you need to increase the storage capacity and we will help you. Please note that ephemeral storage can’t be increased unless you change node flavor.
