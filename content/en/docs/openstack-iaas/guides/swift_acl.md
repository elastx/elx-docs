---
title: "Swift ACL"
description: "Guide for managing Swift permissions with ACLs"
weight: 1
alwaysopen: true
---
## Overview

In this guide we will go through how to manage user permissions for Swift containers using ACLs. 

Due to current limitation on how current privilege/role  management works, the way to go is to create a separate "Swift project". 

The purpose of so called "Swift projects" ("<customername>\_swift") is to work-around current limitations related to our privilege/role management in projects. When a user becomes a member of a project, they get the ability to create/manipulate resources such as virtual instances and volumes, which may not be desirable if your goal is to have a user that only has access to Swift or specific Swift containers/buckets. This is not optimal and we are planning to provide options for better permission granularity, but the currently available work-around is to create a separate project for "Swift usage" which has resources quotas set that prevents it's users from creating/manipulating non-Swift resources.

The Swift project can be used in two ways - to store/manage Swift containers and/or manage Swift-only users.

## How to manage permissions via ACLs

If you want a user to be able to create, manage and upload/download objects for *any Swift containers created in the Swift project*, inviting and assigning the user the role "Object Store" (known as "swiftoperator" in the API/CLI) in “Management” -> “Access Control” -> “Project Users” should be sufficient.

If you instead  want a user to be able to read and/or write to *a specific Swift containter created in the Swift project or any another project you have*, you will need to invite the user to the Swift project, assign them the role "Project Member" and configure Swift container ACLs for the target container(s). We'll go through an example below.

In order to configure Swift ACLs you will need:
- A user with the "Object Store" ("swiftoperator") role in the project that contains the container you want to restrict/provide access to
- The [Swift CLI](https://docs.openstack.org/python-swiftclient/latest/cli/index.html) or another API client capable of configuring ACLs (this is currently not supported through Horizon)
- An OpenStack RC file (openrc), "clouds.yml" or environment variables set for authenticating towards the API as the user used to configure ACLs
- Name of the container you want to configure ACLs for
- ID of the project in which the container is stored and the ID for the *Swift project* if they are not the same (listed under "Identity" -> "Projects" in Horizon or `openstack project list` via the CLI)
- ID of the user you want to restrict/provide access for (accessible through "Identity" -> "Users" in Horizon as that user)

In the following example we'll use the Swift CLI to configure read/write/list access to a specific container *created in the Swift project*

```shell
# Using variables here to make it easier to follow/adapt to new service users and Swift containers
$ SWIFT_PROJECT_ID="b71cd232c8544cf28a7d7aad797cafe9"
$ SWIFT_CONTAINER_NAME="test-container-1"
$ TARGET_USER_ID="whatever_id_it_has"

# Explicitly specifying project ID here, in-case you use an OpenRC/clouds.yml file downloaded from your other projects
$ OS_PROJECT_ID="${SWIFT_PROJECT_ID}" swift post "${SWIFT_CONTAINER_NAME}" --read-acl ".rlistings,${SWIFT_PROJECT_ID}:${TARGET_USER_ID}" --write-acl "${SWIFT_PROJECT_ID}:${TARGET_USER_ID}"
```

If you want to provide/restrict access to a container that has been *created in another project*, the process is similar:

```shell
# Specifying the ID for the other project instead
$ OS_PROJECT_ID="<project-id>" swift post "${SWIFT_CONTAINER_NAME}" --read-acl ".rlistings,${SWIFT_PROJECT_ID}:${TARGET_USER_ID}" --write-acl "${SWIFT_PROJECT_ID}:${TARGET_USER_ID}"
```

_Note: Replace `<project-id>` with the actual Project ID_

If you need any clarification, further guidance or have other questions, feel free to reach out to our support.

## Known limitations

Currently, cross-project ACLs don't work if you want to use the S3 compatibility.

## Further reading

[Swift ACLs](https://docs.openstack.org/swift/train/overview_acl.html)
