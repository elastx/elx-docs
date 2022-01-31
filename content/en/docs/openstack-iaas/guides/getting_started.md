---
title: "Getting started with OpenStack"
description: "Guide to setup OpenStack"
weight: 1
alwaysopen: true
---


Here are the initial steps that you need to perform to start you first instance and access it with ssh.

## Create Network
1. Go to "Project" > "Network" > "Networks"
1. Select "Create Network" > set a network name > "Next" 
1. set subnet name and network address (10.0.1.0/24 for example) > "Next" 
1. add "DNS Name Servers" > "Create"

## Create Router
1. Go to "Project" > "Network" > "Routers"
2. Select "Create Router" > set a router name and select the public network "ext-net-01" > "Create Router"
3. Select the router you just created > "Interfaces" > "Add Interface" > select the subnet you created > "Add Interface"

Now the network is up and ready for you to create the first instance.

## Create ssh key
1. Go to "Project" > "Compute" > "Key Pairs" > select "Create Key Pair" > set key pair name > "Create Key Pair" > save the private key

## Create Security Group
1. Go to "Project" > "Network" > "Security Groups" > select "Create Security Group" > set a name > "Create Security Group"
2. select "Manage Rules" on the security group you created"
3. select "Add Rule" > set "Port" 22 > add an IP address under "CIDR" if you want to limit access > "Add" 

## Create instance
1. Go to "Project" > "Compute" > "Instances" > select "Launch Instance"
1. set instance name > "Next"
1. select "Image" in"Select Boot Source" >  select "No" in "Create New Volume"
1. select image (ubuntu-20.04-server-latest for example) > "Next"
1. select a flavor (v1-standard-1 for example) > "Next"
1. your network should already be selected > "Next"
1. you do not need to select any port > "Next"
1. add the security group you created earlier > "Next"
1. the key pair you created earlier should already be selected 
1. "Launch instance"

## Add a public IP to the instance
1. Go to "Project" > "Compute" > "Instances" > from the "Actions" menu on the instance you created select "Associate Floating IP"
select the "+" button next to the "IP Address" field
1. select "Pool" "elx-public1" > "Allocate IP"
1. "Associate"

## Log in to your new instance 
Use the floating IP and the ssh key you created.

In this example the ssh key pair I created was named mykeypair and the public ip is "1.2.3.4" and the image I used was an Ubuntu image. In this example:

```ssh -i mykeypair.pem ubuntu@1.2.3.4```

The username is different depending on the Linux flavor you are using but you will always use the keypair and not a password.
This is the ssh command you will use is you login from a Linux client. Here is the generic pattern:

```ssh -l UserName -i /path/to/my-keypair.pem 1.2.3.4 ```

Here is a list of the user names for each Linux dist.

Linux flavor	User
CentOS 6	cloud-user
CentOS 7	centos
CoreOS	core
Fedora	fedora
Redhat	cloud-user
Ubuntu	ubuntu
Debian	debian
Heat instances	ec2-user
When using Heat to deploy instances the user name will be ec2-user instead.
