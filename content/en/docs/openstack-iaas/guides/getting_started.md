---
title: "Getting started with OpenStack"
description: "Guide to setup OpenStack"
weight: 1
alwaysopen: true
---

Here are the initial steps that you need to perform to start you first instance and access it with ssh.  
In this example we use an ubuntu image and restrict SSH access.

## Create Network
1. Go to "Project" > "Network" > "Networks"
1. Select "Create Network" > set a network name > "Next" 
1. Set subnet name and network address (10.0.1.0/24 for example) > "Next" 
1. Make sure that "Enable DHCP" is checked.
1. Add "DNS Name Servers" > "Create"

## Create Router
1. Go to "Project" > "Network" > "Routers"
2. Select "Create Router" > set a router name and select the public network "elx-public1" > "Create Router"
3. Select the router you just created > "Interfaces" > "Add Interface" > select the subnet you created > "Add Interface"

Now the network is up and ready for you to create the first instance.

## Create ssh key
1. Go to "Project" > "Compute" > "Key Pairs" 
1. Select "Create Key Pair" > set key pair name > "Create Key Pair" 
1. Save the private key

## Create Security Group
1. Go to "Project" > "Network" > "Security Groups"
1. Select "Create Security Group" > set a name > "Create Security Group"
1. Select "Manage Rules" on the security group you created"
1. Select "Add Rule" > set "Port" 22 > add an IP address under "CIDR" to restrict access > "Add"

## Create instance
1. Go to "Project" > "Compute" > "Instances"
1. Select "Launch Instance" > Set instance name > "Next"
1. Select "Image" in "Select Boot Source" > Select "No" in "Create New Volume"
1. Select image (ubuntu-20.04-server-latest for example) > "Next"
1. Select a flavor (v1-standard-1 for example) > "Next"
1. Your network should already be selected > "Next"
1. You do not need to select any port > "Next"
1. Add the security group you created earlier > "Next"
1. The key pair you created earlier should already be selected.
1. "Launch instance"

## Add a public IP to the instance
1. Go to "Project" > "Compute" > "Instances" > from the "Actions" menu on the instance you created select "Associate Floating IP"
1. Select the "+" button next to the "IP Address" field
1. Select "Pool" "elx-public1" > "Allocate IP"
1. "Associate"

## Log in to your new instance 
Use the floating IP and the ssh key you created.

In this example the ssh key pair I created was named mykeypair and the public ip is "1.2.3.4" and the image I used was an Ubuntu image. In this example:

```ssh -i mykeypair.pem ubuntu@1.2.3.4```

The username is different depending on the Linux flavor you are using but you will always use the keypair and not a password.  
This is the generic pattern to login from a Linux client:

```ssh -l UserName -i /path/to/my-keypair.pem 1.2.3.4 ```

Default UserName is different depending on distribution:

| Linux Distribution   | User       |
|-----------------|------------|
| CentOS 7        | centos     |
| CentOS 8-stream | centos     |
| CentOS 9-stream | cloud-user |
| CoreOS          | core       |
| Fedora          | fedora     |
| Redhat          | cloud-user |
| Ubuntu          | ubuntu     |
| Debian          | debian     |
| Heat instances* | ec2-user*  |  

* When using Heat to deploy instances the user name will be ec2-user instead.  

### Changing the default username

In most modern distributions it's also possible to change the default username when creating a server by utilizing cloud-init.  
The sample configuration below would change the deafult username to "yourusername".

```shell
#cloud-config
system_info:
  default_user:
    name: yourusername
```
