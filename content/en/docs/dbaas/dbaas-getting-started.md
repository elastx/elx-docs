---
title: "Getting started with DBaaS"
description: "Getting started with DBaaS"
weight: 2
alwaysopen: true
---

## Overview
The management of your datastore clusters takes place in our DBaaS Web UI. To create your first datastore go to https://dbaas.elastx.cloud/ and login with your [Elastx IdP account](https://docs.elastx.cloud/docs/tech-previews/idp-ops/).

## Create a datastore
You can create multiple datastores within your DBaaS Project. A datastore is a database cluster which can consist of one or multiple nodes. If you opt for a primary with two replicas you will get three nodes that are spread out on all three of our availability zones. This will ensure the the highest availability that also comes with built-in failover.

To create a new datastore, choose +Create datastore in the Web UI. This will open a configuration wizard.

1. Databases: Choose one of the available database types  (MariaDB, MySQL, PostgreSQL, Redis). If you opt for PostgreSQL, you will have the choice between major versions 11, 14 and 15.

2. Configuration: Add a name and optionally tags to easily categorize your datastore. For the Primary / Replica configuration, the options include, one primary node, one primary node with a single replica or one primary node with two replicas.

3. Cloud service: Only one region, Continue.

4. Resources: Select type of instance to be used with your datastore.   
  
    Storage: choose between Ephemeral or Volume.  
    See [Difference between ephemeral and volume storage](#difference-between-ephemeral-and-volume-storage) for more information. 
    >**Beware:** Please remember that the databases in the datastore node become read-only when 90% or more of the disk space is used and ephemeral storage cannot be extended.  

5. Preview: Review and confirm everything is satisfactory, then proceed to complete the task by clicking finish. Based on the selections made previously, the datastore should be operational within a few minutes.

## Database and User management

### Create a new database
For MariaDB/MySQL you need to create a database before creating a database user.  
For Postgresql you need to create a database user before creating a database.

1. Select the datastore in which you wish to create a database in.
2. Under Databases tab pick Create new database
3. Write a name for the database. For Posgresql select the owner (database user) and click Create.

### Create a new database user

1. Select the datastore in which you wish to create a new user.
2. Navigate to the Users tab, Click on Create Admin user.
3. Add a Username and a Password. For MariaDB/MySQL select the database that the user should be associated with.

### Delete a database

1. Select the datastore in which you wish to delete a database in.
2. Navigate to the Databases tab, find the desired database under the Actions column, and click the trash bin icon to remove the selected database. 
3. Confirm the delete action in the confirmation window.

## Connect to datastore nodes

### Add trusted sources
Go to the Firewall (Connect) tab: Click on the +Create trusted source. Add a CIDR i.e.: 1.2.3.4/32 and a description.

### Connect to datastore nodes

Every datastore cluster has one or two uniquely external DNS names depending on if the datastore is a single node or a primary-replica(s). The DNS names are immutable and does not change over the course of the datastores' lifecycle. In case of primary-replica(s) you get one external DNS name for the primary and one for the replica(s). This is also used with our built-in failover mechanism, please see our [Built-in Failover](#built-in-failover-using-dns) for more information on how to take advantage of this functionality.   
Every node in your datastore cluster also has a Public IP address which can be used if you want to setup your own load-balancing, please see [Load balancing and other features](#load-balancing-and-other-features) for more information.

You will find how to connect to your datastore nodes through their external DNS names in the *overview* tab of the UI.   
If you want to connect through the nodes' IP addresses you can find them in the *nodes* tab.  

### Connection assistant
If you want to use a connection assistant you will find examples on how to configure your connection from various programming languages such as python, node.js, php etc in the *users* tab.

## Delete a datastore

> Please note that the deleted datastore, its backups, users and data will immediately disappear upon deletion. This action cannot be reverted.

1. Go to the list of all datastores
2. Find the target datastore in the list
3. Click on the three dotted lines menu
4. Click the Delete button
4. Confirm the delete action in the confirmation window

## Network and Failover
If you're utilizing floating IPs on our OpenStack or Virtuozzo platforms, it's important to note that all traffic between the nodes will never leave our network. This is advantageous for both latency and security, as the internal routing ensures fast and secure data transmission.

### Built-in Failover Using DNS
Our primary-replica(s) cluster configuration provides robust performance and reliability. In the event of the primary node going down, the database cluster is designed to automatically promote one of the replica nodes to become the new primary. This ensures that your data remains accessible and that write operations can continue with minimal interruption. Our primary-replica(s) cluster provides an immutable external DNS name for the primary, this ensures that if for some reason the current primary node goes unavailable, the built-in failover will automatically promote a new primary and redirect the primary node's dns to point to the new primary nodes's IP address. This is an easy and robust way to quickly handle failover without any user intervention.

### Load Balancing and Other Features
If you want additional functionality or combine failover with for instance load balancing and/or use specific database drivers, this has to be set up in front of your datastore cluster. There are numerous ways this can be set up and configured dependending on the chosen solution. On how to set this up please refer to the documention of the specific solution you plan to use. It’s vital to note that in case of the primary going down, one of the replicas will automatically be promoted as a new primary and you'll need to plan accordingly. We recommend to use the primary's DNS instead of the IP address for ease of use.
 
###### Example of features than can be implemented

* Load Balancer: Implementing a load balancer in front of the database cluster can be configured to detect node failures and also be set up to direct write queries to the primary node and read queries to the replicas.

* Database Drivers: Recommended Drivers: [libpq](https://www.postgresql.org/docs/current/libpq.html) (for PostgreSQL), [MySQL Connector/J](https://dev.mysql.com/doc/connector-j/en/) (for MySQL), [MariaDB Connector/J](https://mariadb.com/kb/en/about-mariadb-connector-j/) (for MariaDB), These drivers and libraries are designed with failover and high availability in mind. They offer features such as connection pooling, automatic retries, and built-in failover support.

## Difference between Ephemeral and Volume storage
*  Ephemeral storage option: This is the ephemeral storage that is included in your selected flavor. It has a static size as shown on the flavor and cannot be resized. It is the fastest storage type we have to offer. It becomes a single point of failure because it is a non-persistent storage that depends on the state of the instance where your datastore node is running. To have redundancy, you need to set up replicas or other ways to recover from failure.

*  Volume storage option: This is the recommended storage alternative. With volume storage you have the ability to choose your own storage size and type. Minimum size requirement is 80GiB. Volume size can also be extended later if needed. We recommend using our latest V2 storage type for best performance and price.  
Please see more information about our latest storage types here: [ECP/OpenStack Block Storage](https://elastx.se/en/openstack/specification).


## Good-to-Know and Limitations

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

#### Importing database dumps to MariaDB/MySQL
Importing backed up database dumps into your datastore using the mysql/mariadb clients also creates binlogs during the import.  
Binlogs can vary in size and a good rule of thumb is to have twice the size of the dump free on the volume before starting the import. This is to ensure the volume is not running out of space during the import.  
Example: You are planning on creating a new datastore and import a 80GiB database dump, you should select a volume with at least 160GiB.

#### Certificates
Currently certificates installed on database nodes are self-signed.
