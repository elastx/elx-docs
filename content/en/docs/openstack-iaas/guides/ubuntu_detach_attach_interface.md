---
title: "Detach & Attach interface on a Ubuntu instance"
description: "Guide on how to detach and attach a network interface on a Ubuntu instance"
weight: 1
alwaysopen: true
---

## Overview



If you need to change interface on a Ubuntu instance, then this is the procedure to use.

1. Run the following command in the instance.

        sudo cloud-init clean

2. Shut down the instance

3. Detach / Attach the network interface

4. Start the instance

5. Reassociate Floating IP with the instance

