---
title: "Change public IP without downtime"
description: "How to change public IP on a node without downtime"
weight: 1
alwaysopen: true
---

## Overview

In Jelastic PaaS you can easily switch IP-addresses by yourself without any downtime.

## Attach new IP-address 

1. Expand your environment. If you hover over your Public IPv4-address, an icon for attaching or detaching IP-addresses will appear.

![Open-in-browser](/img/jelastic-paas/guides/jel_change-public-ip-1.png)

2. Attach a new IP by raising the number of IP-addresses to 2.

![Change-number-of-ips](/img/jelastic-paas/guides/jel_change-public-ip-2.png)

3. Verify that your node has been assigned two IP-addresses.

![Verify-two-ips](/img/jelastic-paas/guides/jel_change-public-ip-3.png)

## Update DNS-records

4. Update relevant DNS records at your DNS provider to point to the new IP address.

*Please keep in mind that your DNS change can take up to 24 hours before it’s completely propagated worldwide. You can verify your DNS propagation
here: [DNS Checker](https://dnschecker.org/)*

## Detach IP-address

*Caution: In this next step we will go through how to detach an IP-address. Once you are ready to remove the IP-address, proceed to the next step.* 

5. Press the Detach IP button to the right of the IP address that you wish to remove from your environment.

![Detach-ip](/img/jelastic-paas/guides/jel_change-public-ip-4.png)

6. Confirm the detachment.

![Confirm-detachment](/img/jelastic-paas/guides/jel_change-public-ip-5.png)

That’s it! If something in this guide is unclear or if you have any questions, feel free to contact us.
