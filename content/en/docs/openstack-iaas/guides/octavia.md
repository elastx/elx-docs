---
title: "Octavia"
description: "Guide for using Octavia LBaaSv2"
weight: 1
alwaysopen: true
---

*OpenStack Octavia* is the next generation load balancer as a service for OpenStack.

Use with Barbican for SSL

## Create a SSL-Terminated Load Balancer

Creating a SSL-terminated Octavia load balancer:

- Generate certificates and keys
- Store certificate key
- Store certificate
- Store certificate chain
- Create container using the stored data
- Create ACL to allow octavia to access the data
- Create Octavia load balancer
- Create listener with certificate data
- Create load balancer pool
- Create pool members
- Create health monitors (optional)
