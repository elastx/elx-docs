---
title: "Network"
description: "Network architecture in the OpenStack cloud"
weight: 1
alwaysopen: true
---

## Overview

The OpenStack tenant networks is implemented as a shared L2 between all availability zones and is tightly integrated with our network infrastructure.
Routing is handled by anycast routing in the switch infrastruture which makes the network extremely performant with low consistent latency.

## Special considerations

### Router Egress NAT

Egress NAT is distributed and handled by the local hypervisor which means that unless a floating ip is associated with a instance it will utilize the public ip-address of the hypervisor where the instance is currently running. If the public ip-address of the instance needs to be known, e.g. needs to be provided to a 3rd party for firewall rules or likewise a floating ip needs to be associated with the instance.

### Router Extra Routes API

The current network design does not yet support the use of Extra Routes in Neutron routers. You can configure Extra Routes in both API and Horizon but they will not be applied to datapath. There are possible workarounds that depends on the what needs to be accomplished.

### Neutron ports with allowed-address-pair

The current network design does not yet fully support the use of allowed-address-pair to utilize instances as a gateway for network traffic (e.g. VPN servers). It does currently work for single addresses (/32 prefix) only.

### Multicast

Multicast traffic Inter-AZ works but is without any guarantee.

### VIP-address

ARP lookups are asynchronous Inter-AZ. When moving VIP-addresses between AZs this can lead to unexpected traffic patterns.
