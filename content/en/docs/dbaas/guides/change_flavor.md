---
title: "Change flavor on datastore nodes"
description: "Overview and example configuration"
weight: 1
alwaysopen: true
---

## Overview
This guide will help you getting started with how to change flavor on datastore nodes.  
Please read the [Good to know](#good-to-know) before proceeding with this guide.  
Changing of flavor works by adding new node(s) with the desired flavor and afterwards delete the old node(s). 
This can be done by using the **scale nodes** function within the web UI. 


### Good to know
>**Beware:** If you are planning on changing flavor on your primary node, it is worth noting that this requires promotion of a new primary node. Promoting a new primary will cause  new writes to be blocked during the process.  
The new primary will also have a different Public IP. Therefore it is recommended to plan accordingly before proceeding.
* If you are already using the maximum amount of nodes, the option to change flavor is to first scale down and then create a new node with the desired flavor.  
* Redis can only be scaled out with at least two nodes at a time . This means that if you are running a single node deployment, it requires you to first scale out to three nodes. When all nodes are up and running you can promote one of the new nodes as primary and then scale down to one node.
* Galera clusters (Multi-Primary) can only be scaled with at least two nodes at a time.


### Changing flavor

#### Add a new node
For this guide we will be using a single node datastore running MariaDB.  
Before proceeding it is always good to create a backup.  
Start by locating your datastore in the web UI and select **Nodes** and then select **Scale Nodes**.
![Show-Details](/img/dbaas/guides/dbaas_change_flavor-1.png)  
<br>
In the pop-up window use the slider to scale out to a second node. Select the flavor you want to use and which availability zone it should be placed in and press save. The new node will be created as a replica.
![Show-Details](/img/dbaas/guides/dbaas_change_flavor-2.png)  

#### Promote new replica as primary
When the new node is up and running it is time to promote it as primary. Please be sure that you have read [Good to know](#good-to-know) before proceeding.  
Select the three dots next to the new replica and select **Promote Replica** 
![Show-Details](/img/dbaas/guides/dbaas_change_flavor-3.png)  
<br>
When the promotion is done, you should see that your new node is the primary node.  
![Show-Details](/img/dbaas/guides/dbaas_change_flavor-4.png)

#### Remove the old node
The last step is to remove the old node that is using the old flavor and is now running as a replica.  
Select **Scale Nodes** and use the slider to scale down. Select the node that should be deleted. Only replicas can be set for deletion. 
![Show-Details](/img/dbaas/guides/dbaas_change_flavor-5.png)
