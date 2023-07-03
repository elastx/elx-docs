---
title: "Swift getting started"
description: "A guide to get started with Swift object storage"
weight: 1
alwaysopen: true
---

## Overview

Swift is Elastx object storage in OpenStack. It provides high availability using all our availability zones. It is also encrypted at rest as per default.
This guide will help you get started with the basics surrounding Swift object storage. We will be using the Swift-cli and OpenStacks Horizon. 


## Swift CLI

Prerequisites: python-swiftclient, application credential.


To be able to use the swift cli client, you first need to source your application credential or if you don’t use MFA you can use the .rc-file which points to your openstack project.

>**Beware:** The following commands executes directly without any questions.

List all available commands: ```swift```.

### Check your authentication variables

Check what the swift client will use as authentication variables  ```swift auth```.

### Create your first container

Lets create your first container by using following command:<br>
``` swift post <container name>```.

```bash 
  $ swift post my_container
```
### Upload files

Upload a file to your container: ```swift upload <container_name> <file_or_folder> ```.
```bash 
  $ swift upload my_container ./file1.txt
  file1.txt

```
### Show containers

To show all your containers, use the following command: ```swift list```.
```bash 
  $ swift list
  my_container


```

Show objects inside your container: ```swift list <container_name>```.
```bash 
  $ swift list my_container
  file1.txt

```
### Show statistics of your containers and objects

You can see statistics, ranging from specific objects to the entire account.
Use the following command to se statistics of the specific container we created earlier.<br>
```swift stat <container_name>```.
```bash 
  $ swift stat my_container
Account: AUTH_7bf53f20d4a2523a8045c42ae505acx
             Container: my_container
               Objects: 1
                 Bytes: 7
              Read ACL:
             Write ACL:
               Sync To:
              Sync Key:
          Content-Type: application/json; charset=utf-8
           X-Timestamp: 1675242117.33639
         Last-Modified: Wed, 01 Feb 2023 09:15:39 GMT
         Accept-Ranges: bytes
      X-Storage-Policy: hdd3
            X-Trans-Id: tx2f1e73d3b29a4aba99c1b-0063da2e2b
X-Openstack-Request-Id: tx2f1e73d3b29a4aba99c1b-0063da2e2b
            Connection: close
```
You can also type  ```swift stat <container_name> <filename>``` to check stats of individual files. If you want to se stats from your whole account, you can type ```swift stat```.

### Download objects

You can download single objects by issuing the following command:<br> ```swift download <container_name> <your_object> -o /path/to/local/<your_object>```. 
```bash 
  $ swift download newcontainer file1.txt -o ./file1.txt
  file1.txt [auth 2.763s, headers 2.907s, total 2.907s, 0.000 MB/s]
```

It's possible to test downloading an object/container without actually downloading, for testing purposes 
```swift download <container-name> --no-download```.

Download all objects from specific container<br>
``` swift download <container_name> -D </path/to/folder/>```.

Download all objects from your account<br>
```swift download --all -D </path/to/folder/>```.

### Delete objects
Delete specific object by issuing the following command:<br> ```swift delete <container_name> <object_name>```.
```bash
  $ swift delete my_container file1.txt
  file1.txt
```
And finally delete specific container by typing the following:<br> ```swift delete <container_name>```.

## OpenStack Horizon
With Openstacks Horizon you get a good overview over your object storage. There are some limitations in Swifts functionality when using Horizon, to fully take advantage of Swifts functions we recommend you to use the swift cli.  
This guide will show you the basics with using Swift object storage in Horizon.

### Create your first container
Navigate to ["Project" → "Object Store" →  "Containers"](https://ops.elastx.cloud/project/containers/) 
Here you will see all the containers in your object storage.  
Choose +Container to create a new container:

![Create-container](/img/openstack-iaas/guides/ops_swift_getting_started-1.png)

Choose a name for your new container:

![Name-container](/img/openstack-iaas/guides/ops_swift_getting_started-2.png)

You will se that a new container has been added, which date it was created and that it is empty.

![Show-container](/img/openstack-iaas/guides/ops_swift_getting_started-3.png)

### Upload your first file
To upload your first file, press the up arrow next to +Folder:

![Upload-file](/img/openstack-iaas/guides/ops_swift_getting_started-4.png)

Select the the file you want to upload:

![Choose-file](/img/openstack-iaas/guides/ops_swift_getting_started-5.png)

### Download file
To download a file, select your container and press Download next to the object.

![Download-file](/img/openstack-iaas/guides/ops_swift_getting_started-6.png)

### View details of an object
You can view details of an object such as Name, Hash, Content Type, Timestamp and Size.  
Select the down arrow next to Download for the object you want to inspect and choose View Details:

![Show-Details](/img/openstack-iaas/guides/ops_swift_getting_started-7.png)

![View-Details](/img/openstack-iaas/guides/ops_swift_getting_started-8.png)

## Further reading
- Swift has an s3 compatible API for applications that don't support the Swift API. You can read more about how to configure Swift for s3cmd <a href="https://docs.elastx.cloud/docs/openstack-iaas/guides/s3_compatibility/">here</a>.  
 - You can find an S3/Swift REST API comparison matrix here at the <a href="https://docs.openstack.org/swift/ussuri/s3_compat.html">OpenStacks documentation</a>.  
 - If you want to use more advanced features, please see the <a href="https://docs.openstack.org/python-swiftclient/ussuri/cli/index.html">OpenStacks documentation for Swift</a>.  
 - Rclone is a good choice if you need more advanced functions while using Swift. You can read more about Rclone's support for Swift <a href="https://rclone.org/">here</a>.
