---
title: "Backup and Restore via DBaaS UI"
description: "Overview and examples of Elastx DBaaS built-in backup functionality"
weight: 1
alwaysopen: true
---

## Overview
All our supported database types comes with built-in backup functionality and is enabled by default. Backups are stored in our object storage, which is encrypted at rest and also utilizes all of our availability zones for highest availability. You can easily set the amount of backups per day, the prefered time of day and the retention period in our DBaaS UI. For MySQL, MariaDB and PostgreSQL we also support creating new datastores from backup, making it easy to create a new database cluster using another cluster as a base.  
For backup pricing, you can use our DBaaS price calculator found here: [ECP-DBaaS](https://elastx.se/en/mysql-dbaas/pricing)

## Good to know
>**Beaware**: Please note that if you delete a datastore, all backups for that datastore will also be deleted. This action cannot be reverted.
* Backups are taken for the whole datastore.
* Maximum backup retention period is 90 days.  
* There's no storage capacity limit for backups within the retention period.
* Incremental backups are supported and enabled by default on MySQL and MariaDB.
* Backups cannot be downloaded locally. To create an offsite backup, you can use one of the CLI-tools. See [here](backup-and-restore-cli/) for some examples.
* Create new datastore from a previously taken backup is supported on MySQL, MariaDB and PostgreSQL.

## Manage backups
Begin by logging into your [Elastx DBaaS account](https://dbaas.elastx.cloud/), choose your datastore and go to Backups.  
Under this tab you will see all the previously taken backups for the chosen datastore, if you just created this datastore, it might be empty.

### Retention Period
To change retention period click on Backup settings at the top right corner, set your prefered retention period and click Save.

### Backup schedules
For datastores running MySQL and MariaDB you have the ability to set schedules for both full and incremental backups.  
To change how often and when your backups should run, click on **Backup Schedules** in the left corner.    
Select the backup type you want to change and choose edit: 
* Incremental backups can be set to run every 15, 30 and 60 minutes.  
* Full backups can be set to run hourly or daily. Set your prefered time in UTC.

### Restore backup on your running datastore
>**Beaware**: Please note that this process will completely overwrite your current data and all changes since your last backup will be lost.

Go to the Backups tab for the datastore you want to restore. Select the prefered backup and click on the three dots under Actions and choose restore.

### Create a new datastore from backup
For MySQL, MariaDB and PostgreSQL you have the ability to use a backup as a base for a new datastore.  
Go to backups and click on the three dots under actions for the backup you want to use as a base and select Create Datastore.  
A new datastore will be created with the same specification and name (with extension \_Copy) as the base datastore.  
When it's finished, you can rename your new datastore by going to Settings > Datastore name.

### Disable backups
>**Beaware**: Not recommended. Please note that if you disable full backups, no backups will be taken after this point until you manually enable it again. 

Go to the backups tab for the datastore you want to pause backups. Select Backup Schedules, click on the three dots for type of backup you want to disable and choose pause. To re-enable backups again, take the same steps and choose enable.
