---
title: "Swift getting started"
description: "A guide to getting started with Swift"
weight: 1
alwaysopen: true
---

## Overview

This guide will help you getting started with the basics surrounding Swift object storage. We will be using Swift cli and Openstack Horizon. 



## Swift CLI

prerequisites: python-swiftclient, application credential.

To be able to use the swift cli client, you first need to source your application credential or if you don’t use MFA (which is recommended) you can use the .rc-file? which points to your openstack project.

>**Beware:** The following commands executes directly without any questions.

List all available commands: ```swift```.

### Check your authentication variables

Check what the swift client will use as authentication variables  ```swift auth```.

#### Create your first container

Lets create your first container by using following command:<br>
``` swift post <container name>```

```bash 
  $ swift post my_container
```
#### Upload files

Upload a file to your container: ```swift upload <container_name> <file_or_folder> ```
```bash 
  $ swift upload my_container ./file1.txt
  file1.txt

```
#### Show containers

To show all your containers, use the following command: ```swift list```
```bash 
  $ swift list
  my_container


```

Show objects inside your container: ```swift list <container_name>```
```bash 
  $ swift list my_container
  file1.txt

```
#### Show statistics of your containers and objects

You can see statistics, ranging from specific objects to the entire account.
Use the following command to se statistics of the specific container we created earlier.<br>
```swift stat <container_name>```
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

#### Download objects

You can download single objects by issuing the following command:<br> ```swift download <container_name> <your_object> -o /path/to/local/<your_object>``` 
```bash 
  $ swift download newcontainer file1.txt -o ./file1.txt
  file1.txt [auth 2.763s, headers 2.907s, total 2.907s, 0.000 MB/s]
```

It's possible to download without actually downloading any objects<br> <dry-run>
```swift download <container-name> --no-download```

Download all objects from specific container<br>
``` swift download <container_name> -D </path/to/folder/>```

Download all objects from your account<br>
```swift download --all -D </path/to/folder/>```

#### Delete objects
Delete specific object by issuing the following command:<br> ```swift delete <container_name> <object_name>```
```bash
  $ swift delete my_container file1.txt
  file1.txt
```
And finally delete specific container by typing the following:<br> ```swift delete <container_name>```


#### Futher reading

If you want use more advanced functions, then rclone is a good choice. Rclone has support for swift, read more about Rclone <a href="https://rclone.org/">here</a>.