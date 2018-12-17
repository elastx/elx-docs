---
title: "Network"
description: "Network architecture in the OpenStack cloud"
weight: 1
alwaysopen: true
---

# Overview
The OpenStack tenant networks is implemented as a shared L2 between all availability zones and is tightly integrated with our network infrastructure.
Routing is handled by anycast routing in the switch infrastruture which makes the network extremely performant with a low consistent latency.

## Special considerations

### Egress NAT
Egress NAT is handled by the local hypervisor which means that unless a floating IP-address is associated with a VM it will utilize the public IP-address of the hypervisor where the VM currently resides. If the public IP of the VM needs to be known, for example if provided to a 3rd party for firewall rules or other configuration a floating ip needs to be associated with the VM.

### Gateway VM's with allowed-address-pair
Our current network design does not yet support the use of allowed-address-pair to utilize VM's as a gateway for traffic (VPN servers for example). It does currently work for single addresses (/32 range) only.
