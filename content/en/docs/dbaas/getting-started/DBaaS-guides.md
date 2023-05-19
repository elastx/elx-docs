---
title: "Getting started with DBaaS"
description: "Getting started with DBaaS"
weight: 2
alwaysopen: true
---

## Create datastore

1. Datastores: To create a new datastore, choose +Create datastore.

2. Databases: Choose one of the available database types  (MariaDB, MySQL, PostgreSQL, Redis). If you opt for PostgreSQL, you will have the choice between major versions 11 and 14.

3. Configuration: Add a name and optionally tags to easily categorize your datastore. Choose Multi-Primary or Primary / Replicas. For the Primary / Replica configuration, the options include, one primary node, one primary node with a single replica or one primary node with two replicas.

4. Cloud service: Only one region, Continue.

5. Resources: Select type of instance to be used with your datastore. Choose between Ephemeral or volume Storage. Upon choosing 'Volumes', you will have the options of 'Dynamic', '16k IOPS', or '8k IOPS' as available volume types. Lastly if volume storage is chosen, you can specify the desired size of the disk.

6. Preview: Review and confirm everything is satisfactory, then proceed to complete the task by clicking finish. Based on the selections made previously, the datastore should be operational within a few minutes.

### Limitations

#### All databases in the datastore will use the same database version
For example, if you create a datastore with PostgreSQL 11, then all the databases in this datastore will use PostgreSQL 11.
#### Backup copy gets stored on the node
Datastore backup copy gets stored locally on the node - affects capacity needs for a datastore.

#### Nodes and datastores are created one by one
When deploying a new datastore or adding a new node, all other actions are added to a queue. If a deploy gets stuck, no other deploys can get started, because they are waiting for that deploy job to finish. A node deploy that gets stuck cannot be deleted from the CCX UI. A datastore deploy that gets stuck cannot be deleted from the CCX UI.

#### Good to know for ephemeral storage
Ephemeral storage option: this is the ephemeral storage that is included in your selected flavor. It has a static size as shown on the flavor and cannot be resized. It is the fastest storage type we have to offer. It becomes a single point of failure because it is a non-persistent storage that depends on the state of the instance where your datastore node is running. To have redundancy, you need to set up replicas or other ways to recover from failure.


## Delete datastore

1. Go to the list of all datastores
2. Find the target datastore in the list
3. Click on the three dotted lines menu
4. Click the Delete button
4. Confirm the delete action in the confirmation window


### Good to know

Please note that the deleted datastore will immediately disappear upon deletion. So if you want to follow up on anything, you need to copy the datastore ID and save it somewhere for future reference.

## Connect to datastore nodes

1. Firewall (Connect) tab: Click on the +Create trusted source. Add a CIDR i.e.: 1.2.3.4/32 and a description.
2. Users tab: Create Admin user, Choose username, password and what database it should be related to.
3. Users tab: Use Connection assistant to get examples from various programming languages such as python, node.js, php etc.


### Limitations

Connect to node using public IP address
The user must connect to a datastore node via its public IP address.


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
