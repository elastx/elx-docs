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
    >**Beware:** Please remember that the databases in the datastore node become read-only when 90% or more of the disk space is used and ephemeral storage size can't be resized.  

    Ephemeral storage option: this is the ephemeral storage that is included in your selected flavor. It has a static size as shown on the flavor and cannot be resized. It is the fastest storage type we have to offer. It becomes a single point of failure because it is a non-persistent storage that depends on the state of the instance where your datastore node is running. To have redundancy, you need to set up replicas or other ways to recover from failure.

    Upon choosing 'Volumes', you will have the options of 'Dynamic', '16k IOPS', or '8k IOPS' as available volume types. Lastly if volume storage is chosen, you can specify the desired size of the disk. Read more about the volume types at our [OpenStack Specification](https://elastx.se/en/openstack/specification).

5. Preview: Review and confirm everything is satisfactory, then proceed to complete the task by clicking finish. Based on the selections made previously, the datastore should be operational within a few minutes.

### Limitations

#### All databases in the datastore will use the same database version
For example, if you create a datastore with PostgreSQL 11, then all the databases in this datastore will use PostgreSQL 11.

#### Before you restore from backup: storage usage must be max 65%
When you wish to restore a datastore from backup, you need to ensure that your storage usage on each datastore node is at maximum 65%. This is because the current restore from backup method will use your datastore nodes storage to temporarily store the backup files during the restore. To ensure this, you need to use the Scale Storage functionality when needed, before doing a restore from backup. After restore from backup is done, you can resize the datastore nodes back to the desired size again.

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

