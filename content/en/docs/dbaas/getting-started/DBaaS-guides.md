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

2. Configuration: Add a name and optionally tags to easily categorize your datastore. For the Primary / Replica configuration, the options include, one primary node, one primary node with a single replica or one primary node with two replicas.

3. Cloud service: Only one region, Continue.

4. Resources: Select type of instance to be used with your datastore.   
  
    Storage: choose between Ephemeral or Volumes. 
    >**Beware:** Please remember that the databases in the datastore node become read-only when 90% or more of the disk space is used and ephemeral storage size can't be resized.  

    Ephemeral storage option: this is the ephemeral storage that is included in your selected flavor. It has a static size as shown on the flavor and cannot be resized. It is the fastest storage type we have to offer. It becomes a single point of failure because it is a non-persistent storage that depends on the state of the instance where your datastore node is running. To have redundancy, you need to set up replicas or other ways to recover from failure.

    Upon choosing 'Volumes', you will have the options of selecting Volume type either the preferred v2 volumes with different IOPS performance classes 1k-64k or the legacy v1 volumes 'Dynamic', '16k IOPS', or '8k IOPS'. Lastly if volume storage is chosen, you can specify the desired size of the disk. Read more about the volume types at our [OpenStack Specification](https://elastx.se/en/openstack/specification).

5. Preview: Review and confirm everything is satisfactory, then proceed to complete the task by clicking finish. Based on the selections made previously, the datastore should be operational within a few minutes.

### Limitations

#### All databases in the datastore will use the same database version
For example, if you create a datastore with PostgreSQL 11, then all the databases in this datastore will use PostgreSQL 11.

#### Nodes and datastores are created one by one
When deploying a new datastore or adding a new node, all other actions are added to a queue.

#### Maximum concurrent database connections
DBaaS sets the maximum concurrent database conneciton (max_connections) when creating a new datastore or node. 
It is being set following values:

* `Postgres       25 per GB RAM`
* `MySQL/MariaDB  75 per GB RAM`

This number is direcly related to chosen datastore type and node flavor. Hence a larger flavor allows a higher number of concurrent connections.

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

Every datastore cluster has one or two uniquely external DNS names depending on if the datastore is a single node or a primary-replica(s). The DNS names are immutable and does not change over the course of the datastores' lifecycle. In case of primary-replica(s) you get one external DNS name for the primary and one for the replica(s). This is also used with our built-in failover mechanism, please see our [Built-in Failover](#built-in-failover-using-dns) for more information on how to take advantage of this functionality.   
Every node in your datastore cluster also has a Public IP address which can be used if you want to setup your own load-balancing, please see [Load balancing and other features](#load-balancing-and-other-features) for more information.

You will find how to connect to your datastore nodes through their external DNS names in the *overview* tab of the UI.   
If you want to connect through the nodes' IP addresses you can find them in the *nodes* tab.  

##### Connection assistant
If you want to use a connection assistant you will find examples on how to configure your connection from various programming languages such as python, node.js, php etc in the *users* tab.

### Built-in Failover Using DNS
Our primary-replica(s) cluster configuration provides robust performance and reliability. In the event of the primary node going down, the database cluster is designed to automatically promote one of the replica nodes to become the new primary. This ensures that your data remains accessible and that write operations can continue with minimal interruption. Our primary-replica(s) cluster provides an immutable external DNS name for the primary, this ensures that if for some reason the current primary node goes unavailable, the built-in failover will automatically promote a new primary and redirect the primary node's dns to point to the new primary nodes's IP address. This is an easy and robust way to quickly handle failover without any user intervention.

### Load Balancing and Other Features
If you want additional functionality or combine failover with for instance load balancing and/or use specific database drivers, this has to be set up in front of your datastore cluster. There are numerous ways this can be set up and configured dependending on the chosen solution. On how to set this up please refer to the documention of the specific solution you plan to use. It’s vital to note that in case of the primary going down, one of the replicas will automatically be promoted as a new primary and you'll need to plan accordingly. We recommend to use the primary's DNS instead of the IP address for ease of use.
 
###### Example of features than can be implemented

* Load Balancer: Implementing a load balancer in front of the database cluster can be configured to detect node failures and also be set up to direct write queries to the primary node and read queries to the replicas.

* Database Drivers: Recommended Drivers: [libpq](https://www.postgresql.org/docs/current/libpq.html) (for PostgreSQL), [MySQL Connector/J](https://dev.mysql.com/doc/connector-j/en/) (for MySQL), [MariaDB Connector/J](https://mariadb.com/kb/en/about-mariadb-connector-j/) (for MariaDB), These drivers and libraries are designed with failover and high availability in mind. They offer features such as connection pooling, automatic retries, and built-in failover support.

##### Network Advantages on Our Platforms

If you're utilizing floating IPs on our OpenStack or Jelastic platforms, it's important to note that all traffic between the nodes will never leave our network. This is advantageous for both latency and security, as the internal routing ensures fast and secure data transmission.

Final Notes

Setting up a failover mechanism is not just an optional step but a recommended practice to ensure database availability and integrity. Without a proper failover setup, you risk prolonged downtime and possible data inconsistencies during node failures or maintenance activities.


Customer must install a loadbalancer or use failover friendly database driver, e.g connector/J for MySQL or MariaDB or similar for PostgreSQL like libpq.
Thus, if the database driver that the customer uses does not support it, they must currently update the connection string if there is a failure.
Note about certificates: certs installed on database nodes are self-signed. This is nothing we can change now.

### Importing database dumps to MariaDB/MySQL
Importing backed up database dumps into your datastore using the mysql/mariadb clients also creates binlogs during the import.  
Binlogs can vary in size and a good rule of thumb is to have twice the size of the dump free on the volume before starting the import. This is to ensure the volume is not running out of space during the import.  
Example: You are planning on creating a new datastore and import a 80GiB database dump, you should select a volume with at least 160GiB.

## Life-cycle management and upgrade
CCX will keep your system updated with the latest security patches for both the operating system and the database software.

You will be informed when there is a pending update and you have two options:
- Apply the update now
- Schedule a time for the update

The update will be performed using a roll-forward upgrade algorithm:
1. The oldest replica (or primary if no replica exist) will be selected first
2. A new node will be added with the same specification as the oldest node and join the datastore
3. The oldest node will be removed
4. 1-3 continues until all replicas (or primaries in case of a multi-primary setup)  are updated.
5. If it is a primary-replica configuration then the primary will be updated last. A new node will be added, the new node will be promoted to become the new primary, and the old primary will be removed.

> Please be aware that the floating ip addresses assigned to the nodes may change. It's recommended to instead use the external DNS name found in the Overview tab of the UI.

### Upgrade now
This option will start the upgrade now.

### Scheduled upgrade
The upgrade will start at a time (in UTC) and on a weekday which suits the application.
Please note, that for primary-replica configurations, the update will cause the current primary to be changed.
