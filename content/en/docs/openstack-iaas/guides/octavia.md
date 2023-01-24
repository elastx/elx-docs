---
title: "Octavia"
description: "Load balancer as a service for OpenStack"
weight: 1
alwaysopen: true
---

This is an example of a minimal setup that includes a basic HTTP loadbalancer.
Here is a short explanation of a minimal (configuration) setup from GUI (Horizon).

1. Network -> Loadbalancer -> Create loadbalancer

1. Load Balancer Details: 
Subnet: Where your webservers live

1. Listener Details:
Select HTTP, port 80.

1. Pool Details:
This is your "pool of webservers".
Select Algoritm of preference.

1. Pool members:
Select your webservers.

1. Finally, proceed to "Create Loadbalancer".


Note, the loadbalancer will not show up in the Network Topology graph. This is expected.

Octivia features numerous configuration variations.
The full reference of variations and CLI guide can be found here:
[https://docs.openstack.org/octavia/train/user/guides/basic-cookbook.html](https://docs.openstack.org/octavia/train/user/guides/basic-cookbook.html)

Take note that an additional CLI client is required to access the full potential as described above.
[https://docs.openstack.org/python-octaviaclient/latest/cli/index.html#loadbalancer](https://docs.openstack.org/python-octaviaclient/latest/cli/index.html#loadbalancer)
