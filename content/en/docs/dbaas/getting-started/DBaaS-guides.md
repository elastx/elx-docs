---
title: "Getting started with DBaaS"
description: "Getting started with DBaaS"
weight: 2
alwaysopen: true
---

## Login to DBaaS Web UI
Go to https://dbaas.elastx.cloud/ and login with your [Elastx IdP account](https://docs.elastx.cloud/docs/tech-previews/idp-ops/).

## Create datastore

To create a new datastore, choose +Create datastore in the Web UI. This will open a configuration wizard.

1. Databases: Choose one of the available database types  (MariaDB, MySQL, PostgreSQL, Redis). If you opt for PostgreSQL, you will have the choice between major versions 11 and 14.

2. Configuration: Add a name and optionally tags to easily categorize your datastore. Choose Multi-Primary or Primary / Replicas. For the Primary / Replica configuration, the options include, one primary node, one primary node with a single replica or one primary node with two replicas.

3. Cloud service: Only one region, Continue.

4. Resources: Select type of instance to be used with your datastore.   
  
    Storage: choose between Ephemeral or Volumes. 

    Ephemeral storage option: this is the ephemeral storage that is included in your selected flavor. It has a static size as shown on the flavor and cannot be resized. It is the fastest storage type we have to offer. It becomes a single point of failure because it is a non-persistent storage that depends on the state of the instance where your datastore node is running. To have redundancy, you need to set up replicas or other ways to recover from failure.

    Upon choosing 'Volumes', you will have the options of 'Dynamic', '16k IOPS', or '8k IOPS' as available volume types. Lastly if volume storage is chosen, you can specify the desired size of the disk. Read more about the volume types at our [OpenStack Specification](https://elastx.se/en/openstack/specification).

5. Preview: Review and confirm everything is satisfactory, then proceed to complete the task by clicking finish. Based on the selections made previously, the datastore should be operational within a few minutes.

### Limitations

#### All databases in the datastore will use the same database version
For example, if you create a datastore with PostgreSQL 11, then all the databases in this datastore will use PostgreSQL 11.

#### Backup copy temporarily stored on the node
A datastore backup copy gets temporarily stored locally on the node before being uploaded to object storage. This will have an effect on capacity needs for a datastore.

#### Nodes and datastores are created one by one
When deploying a new datastore or adding a new node, all other actions are added to a queue.

## Delete datastore

> Please note that the deleted datastore, its backups, users and data will immediately disappear upon deletion. This action cannot be reverted.

1. Go to the list of all datastores
2. Find the target datastore in the list
3. Click on the three dotted lines menu
4. Click the Delete button
4. Confirm the delete action in the confirmation window

## Create database in datastore

1. Select the datastore in which you wish to create a database in.
2. Under ‘Databases’ tab pick Create new database
3. Write a name for the database and click Create.


## Delete database in datastore

1. Select the datastore in which you wish to delete a database in.
2. Navigate to the 'Databases' tab, find the desired database under the 'Actions' column, and click the trash bin icon to remove the selected database. 
3. Confirm the delete action in the confirmation window.

## Create database user

1. Select the datastore in which you wish to create a new user.
2. Navigate to the ‘Users’ tab, Click on ‘Create Admin user’.
3. Add Username, Password and which database the user should be associated with

## Connect to datastore nodes

### Add trusted sources
Go to the Firewall (Connect) tab: Click on the +Create trusted source. Add a CIDR i.e.: 1.2.3.4/32 and a description.

### Connect to datastore nodes
Every datastore node has a public IP address.

You can find the public IP addresses in the Nodes tab.

### Connection assistant
In the Users tab you can use the Connection assistant to get examples from various programming languages such as python, node.js, php etc on how to configure your connection.

### Important: Setting Up Failover for Your Database Cluster

Our cluster configurations whether it's a primary-replica-replica setup or a multi-primary Galera cluster provide robust performance and reliability. However, to maximize the benefits of our cluster setup, it's crucial to implement your own failover mechanism. This is especially vital for ensuring seamless database operations and high availability.

Each node in the database cluster is assigned a unique floating IP for ease of access. However, these floating IPs are tied to individual nodes. If a node fails or if a primary node is replaced, merely having these IPs won't suffice for automated failover.

##### Network Advantages on Our Platforms

If you're utilizing floating IPs on our OpenStack or Jelastic platforms, it's important to note that all traffic between the nodes will never leave our network. This is advantageous for both latency and security, as the internal routing ensures fast and secure data transmission.

###### Your Options for Failover Solutions

1.  Load Balancer: Implementing a load balancer in front of the database cluster can automate the failover process. The load balancer can be configured to detect node failures and reroute traffic to a functional node accordingly. If your cluster is running in a primary-replica configuration, the load balancer can also be set up to direct write queries to the primary node and read queries to the replicas.

2.  DNS-Based Failover: Alternatively, you could set up DNS-based failover. In this configuration, you would set up a DNS record pointing to the primary database node. If the primary node were to fail, a quick DNS update could reroute the traffic to a newly promoted primary node. Note that DNS changes might take some time to propagate, depending on your DNS settings.

###### Failover-Friendly Database Drivers

Recommended Drivers: PgBouncer (for PostgreSQL) or libpq, MySQL Connector/J (for MySQL), These drivers and libraries are designed with failover and high availability in mind. They offer features such as connection pooling, automatic retries, and built-in failover support.

Final Notes

Setting up a failover mechanism is not just an optional step but a recommended practice to ensure database availability and integrity. Without a proper failover setup, you risk prolonged downtime and possible data inconsistencies during node failures or maintenance activities.


Customer must install a loadbalancer or use failover friendly database driver, e.g connector/J for MySQL or similar for PostgreSQL, libpq also can handle it.
Thus, if the database driver that the customer uses does not support it, they must currently update the connection string if there is a failure.
Note about certificates: certs installed on database nodes are self-signed. This is nothing we can change now.
