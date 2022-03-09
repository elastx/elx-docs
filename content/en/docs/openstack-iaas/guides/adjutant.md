---
title: "Adjutant"
description: "User and project management through Horizon, Openstack web interface"
weight: 1
alwaysopen: true
---

## Overview

*OpenStack Adjutant* is a service that allows users to manage projects and their users directly from Horizon.

## User management

Users can be managed directly from the [management tab](https://ops.elastx.cloud/management/project_users/) in Horizon dashboard.

To invite a new member to your project(s) go to "Management" -> "Access Control" -> "Project Users" in the menu, and then click "Invite User" on the right hand side. A popup will appear with a textbox where you can type the email of the new user. Below the textbox you can chose which roles (described below) to assign that user. Click "Invite" when done and an invite will be sent via email. 

_Note: If the user doesn't have an OpenStack account with us already, they will have to follow the email instructions and sign up._

There are a couple of roles that can be assigned to users inside of a project:

- Load Balancer - Allow access to manage load balancers (Octavia).
- Object Store - Allow access to manage objects in object store (Swift).
- Orchestration - Allow access to manage orchestration templates (Heat).
- Project Administrator - Full control over the project, including adding and removing other project administrators.
- Project Member - Allow access to core services such as compute (Nova), network (Neutron) and volume (Cinder).
- Project Moderator - Can invite and manage project members, but not project administrators.
- Secret Store - Allow access to manage objects inside of secret store (Barbican).
