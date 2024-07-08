---
title: Getting started
description: Configuring DNS and using the service
---
## Overview

In short the required steps are:

1. Contact the Elastx Support to get user account and password for the SMTP server
2. For each domain you want to send emails from:
	1. Create DNS record for Elastx challenge token (for each user account)
	2. Create DNS SPF record
	3. Create DNS DKIM record
	4. Create DNS DMARC record

Once these steps are completed you can use our SMTP server to send emails.

If you are unfamiliar with SPF, DKIM and DMARC [please see this article](/docs/mail-relay/email-and-dns/).

## Terminology and general info

| Term           | Description                                                                    |
| -------------- | ------------------------------------------------------------------------------ |
| sender address | The sender email address for the emails you send (no relation to user account) |
| user account   | Your user account name for our SMTP server (no relation to sender address)     |

Please keep in mind that when you create a DNS record for the Elastx challenge token, that user account will be allowed to send emails with **any** sender address for the domain name.

## DNS records

If you use multiple sender domains all domain names will need the below DNS records configured.

Example: You are using sender addresses `tom@example.com` and `alice@example.se` - this means the below domain names will need to be configured with the correct DNS records:

- `example.com`
- `example.se`

### Elastx Challenge token

This record authorizes a user account to use the domain as sender address for emails.

Each user account will need a record for each domain they should be allowed to use as sender address.

The record is created as a TXT record directly under the sender domain name - ie. `domain.com`.

A simple DNS lookup should return something like:

```shell
$ dig +short domain.com TXT  
"elastx-mrs=f7ee5ec7312165148b69fcca1d29075b14b8aef0b5048a332b18b88d09069fb7"  
(..)
```

To generate the value of the `elastx-mrs` record, take the SHA256 sum of your user account email address:

```shell
echo "elastx-mrs=$(echo -n "user@domain.com" | sha256sum | cut -d ' ' -f 1)"
```

Note that the address used above should be your user account, not your sender address.

### SPF record

This record determines what email servers are allowed to use the domain name as sender address.

The record is a DNS TXT record for `domain.com` where `domain.com` is your sender address domain name.

A basic value that only allows Elastx email servers:

```
"v=spf1 include:elastx.email -all"
```

### DKIM record

DNS TXT record should be created for `elastx._domainkey.yourdomain.com` with value as provided by Elastx. Replace `yourdomain.com` with your sender address domain name.

Due to the size of the record it will be split into multiple TXT records. Ie. a DNS lookup will show something similar to:

```shell
$ dig elastx._domainkey.yourdomain.com TXT
(..)
;; ANSWER SECTION:  
elastx._domainkey.yourdomain.com. 1800 IN    TXT     "v=DKIM1; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwHsOJDTnxAkcz/RBek0XDqLaSZov/icY7mZHUSIV7gbHRVLhMWKvWqDV56WdbO+tVo2  
Gaf298Jo0WxwGsIUe0zi6dT0WXgv2zhP0KDT5aRu4q34SsLvrDe218xOC677gm6xUcFaqIMeiU73b9osCDlAxnNSwa2pjxx9yeO6py75tfzw86YkKUvPXPUW754E6mu/k+/4q" "z4NeFnGrCyHLr5rlyxpljMyL8eD13VRP3am  
kCl3Bcgkzt/JWLLa3/9X+N8gkWbB1W2RHAxacvxErSN5K8UHOAT3cUR3qvPGjE4iIKLoU1IkH7s8Gud5gHkiiY5opgDhdfz2kiILyrSv5DQIDAQAB"
(..)
```

### DMARC record

DNS TXT record should be created for `_dmarc.yourdomain.com` where `yourdomain.com` is your sender address domain name.

Elastx does not have any specific requirements for the value, it just needs to be a valid DMARC policy.

Example value:

```
v=DMARC1; p=quarantine; adkim=r; aspf=r;
```

## SMTP server

Configure your application/service with the address to our SMTP server (below) and your user account + password.

| Property | Value                       |
| -------- | --------------------------- |
| Address  | smtp.elastx.email           |
| Port     | 587                         |
| Protocol | SMTP + STARTTLS (preferred) |
