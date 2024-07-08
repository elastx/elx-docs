---
title: "Cloud Connect"
description: "Make a physical connection to Elastx"
alwaysopen: true
---

## General
Cloud Connect is a service for customers to make a physical connection to Elastx public cloud.
#### Locations
The service is offered in our availability zones:
- Elastx STO1
- Elastx STO2
- Elastx STO3

Customers can also connect at "Private Peering Facilities" locations on [PeeringDB](https://www.peeringdb.com/net/9712).

#### Media
The service only allows fiber-based connections. The following physical media is supported. 
Customer needs to specify which media they want to connect with.

10G ports:
- 1000BASE-LX (1310 nm)
- 10GBASE-LR (1310 nm)

100G ports:
- 100GBASE-LR4 (1310 nm)

#### Data Plane Protocols
- MTU 1500 is default. This can be increased to MTU 9000.
- VLAN encapsulation (IEEE 802.1Q) is recommended. All (1-4093) VLAN numbers are available.
- Link Aggregation Control Protocol (IEEE 802.3ad) is supported.

#### Control Plane Procotols
- Border Gateway Protocol (BGP) is recommended.

## Border Gateway Protocol (BGP)
Elastx currently supports IPv4 Address Family (AFI 1) Unicast (SAFI 1).

#### Private peering
Customer can advertise any network, including 0/0 for default routing. Elastx needs to informed of the networks prior to advertisement. 
 
Any AS numbers within 64512–65534, 4200000000–4294967294 (RFC 6996) can be used. With the exception of reservation 4258252000-4258252999. 
 
Public AS numbers can be approved after ownership verification.

#### Public peering
Customer can only advertise networks assigned by Elastx. AS numbers are assigned by Elastx. 
 
Public AS numbers can be approved after ownership verification. 
