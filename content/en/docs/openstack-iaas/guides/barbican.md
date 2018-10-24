---
title: "Barbican"
description: "Guide for using barbican"
weight: 1
alwaysopen: true
---

## Overview

*OpenStack Barbican* is a key management service for storing highly sensitive data like private keys for certificates and passwords which needs to be available for applications during runtime.

ELASTX Barbican service is backed by physical HSM appliances to ensure that all data is securely stored.

REST API reference can be found here: [https://docs.openstack.org/barbican/queens/api/index.html](https://docs.openstack.org/barbican/queens/api/index.html)

Secrets in Barbican have a special design with regards to ID, they are always referenced by a "secret href" instead of a UUID! (This will change in a later release!)

## Secret types

There are a few types of secrets that are handled by barbican:

- symmetric - Used for storing byte arrays such as keys suitable for symmetric encryption.
- public - Used for storing the public key of an asymmetric keypair.
- private - Used for storing the private key of an asymmetric keypair.
- passphrase - Used for storing plain text passphrases.
- certificate - Used for storing cryptographic certificates such as X.509 certificates.
- opaque - Used for backwards compatibility with previous versions of the API without typed secrets. New applications are encouraged to specify one of the other secret types.

## Store and fetch a passphrase using openstack cli

Make sure you have installed the openstack python client and the barbican python client.

Store a passphrase as a secret:

```shell
$ openstack secret store --secret-type passphrase --name "test passphrase" --payload 'aVerYSecreTTexT!'
+---------------+-------------------------------------------------------------------------------+
| Field         | Value                                                                         |
+---------------+-------------------------------------------------------------------------------+
| Secret href   | https://ops.elastx.cloud:9311/v1/secrets/d9e88d84-c668-48d9-a051-f0df2e23485b |
| Name          | test passphrase                                                               |
| Created       | None                                                                          |
| Status        | None                                                                          |
| Content types | None                                                                          |
| Algorithm     | aes                                                                           |
| Bit length    | 256                                                                           |
| Secret type   | passphrase                                                                    |
| Mode          | cbc                                                                           |
| Expiration    | None                                                                          |
+---------------+-------------------------------------------------------------------------------+
```

Get information (only metadata) about the secret

```shell
$ openstack secret get https://ops.elastx.cloud:9311/v1/secrets/d9e88d84-c668-48d9-a051-f0df2e23485b
+---------------+-------------------------------------------------------------------------------+
| Field         | Value                                                                         |
+---------------+-------------------------------------------------------------------------------+
| Secret href   | https://ops.elastx.cloud:9311/v1/secrets/d9e88d84-c668-48d9-a051-f0df2e23485b |
| Name          | test passphrase                                                               |
| Created       | 2018-12-18T12:13:34+00:00                                                     |
| Status        | ACTIVE                                                                        |
| Content types | {u'default': u'text/plain'}                                                   |
| Algorithm     | aes                                                                           |
| Bit length    | 256                                                                           |
| Secret type   | passphrase                                                                    |
| Mode          | cbc                                                                           |
| Expiration    | None                                                                          |
+---------------+-------------------------------------------------------------------------------+
```

Get the actual secret

```shell
$ openstack secret get --payload https://ops.elastx.cloud:9311/v1/secrets/d9e88d84-c668-48d9-a051-f0df2e23485b
+---------+------------------+
| Field   | Value            |
+---------+------------------+
| Payload | aVerYSecreTTexT! |
+---------+------------------+
```

## Store and fetch a passphrase using the REST API (curl examples)

First get a keystone authentication token (using `openstack token issue` for example).

Store a passphrase as a secret:

```shell
Note that payloads is always base64 encoded when uploaded!
$ echo 'AnotHeRs3crEtT3xT!' | base64
QW5vdEhlUnMzY3JFdFQzeFQhCg==

$ curl -H "X-Auth-Token: $TOKEN" \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    https://ops.elastx.cloud:9311/v1/secrets -d '{
      "name": "Test Passphrase REST",
      "secret_type": "passphrase",
      "payload": "QW5vdEhlUnMzY3JFdFQzeFQhCg==",
      "payload_content_type": "application/octet-stream",
      "payload_content_encoding": "base64",
      "algorithm": "AES",
      "bit_length": 256,
      "mode": "CBC"
  }' | python -m json.tool
{
    "secret_ref": "https://ops.elastx.cloud:9311/v1/secrets/85b2df94-a44b-452b-807b-ddcee83d824b"
}
```

Get the secret payload

```shell
$ curl -H "X-Auth-Token: $TOKEN" \
    -H 'Accept: application/octet-stream' \
    https://ops.elastx.cloud:9311/v1/secrets/85b2df94-a44b-452b-807b-ddcee83d824b/payload
AnotHeRs3crEtT3xT!
```
