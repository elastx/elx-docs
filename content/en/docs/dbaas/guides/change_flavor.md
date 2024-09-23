---
title: "Change flavor on datastore nodes"
description: "Overview and example of changing flavors on nodes in Elasx DBaaS"
weight: 1
alwaysopen: true
---

## Overview
This guide will show you how to change flavors on datastore nodes in Elastx DBaaS.  
Changing flavor requires adding a new node with the desired flavor and removing the old node.
This is done by using the node scaling functionality built into our DBaaS. By using a combination of scaling and promoting a replica as primary, the disruption time when changing flavor on a primary node is reduced.  
>**Important:** Be sure to read the [Good to know](#good-to-know) before proceeding with this guide.  

### Good to know
* If you are planning on changing flavor on your primary node, it is worth noting that this entails a failover process by promoting a replica as the new primary. During this process all new writes will be blocked. 
The new primary will also get a different Public IP from the previous primary, therefore it is recommended to use the external DNS name of the primary instead of the IP when connecting to your datastore. You can read more about this [here](../../dbaas-getting-started/#connect-to-datastore-nodes-1).
* If the maximum amount of nodes are already in use, you first have to scale-in one node and then scale-out with a new node using the desired flavor.
* Redis can only be scaled-out with at least two nodes at a time. This means that if you are running a single node deployment, it requires you to first scale-out to three nodes and when all nodes are up and running, you can start promoting one of the new nodes as primary before scaling-in to one node.   
  
  
---

## Changing flavor
In this example we will be changing flavor on a single node datastore running MariaDB.

### Add a new node to your datastore
Start by locating your datastore in the DBaaS UI and go to the **Nodes** section, select **Nodes Configurations** and choose **Scale Nodes**. In the pop-up window, use the slider to scale-out to a second node. Select the flavor you want to use and the availability zone it should be placed in and press save. This will add a new replica to your datastore with your chosen flavor.
![Show-Details](/img/dbaas/guides/dbaas_change_flavor-1.png)  

---

### Promote new replica as primary
>**Important:** Make sure to have read [Good to know](#good-toknow) and have a fresh backup of your datastore before proceeding.

To be able to use your new node as a primary, you first have to promote it.
Select the three dots next to the new replica and choose **Promote Replica**, this will start the process of changing primary.  
  
![Show-Details](/img/dbaas/guides/dbaas_change_flavor-2.png)  

When the process has finished, your newly added node is now running as primary.  

---

### Remove the old node
The last step is to remove the old node that is now running as a replica in your datastore.  
Select **Nodes Configurations** again and choose **Scale Nodes**. Use the slider to scale-in the number of nodes and mark the checkbox of the repliaca that should be deleted.
  
![Show-Details](/img/dbaas/guides/dbaas_change_flavor-3.png)
