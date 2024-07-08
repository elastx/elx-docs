---
title: Email and DNS
description: General info on different types of DNS records for email
---

DNS plays a vital role in regards to email, there are three types of DNS records that are essential to ensuring your emails reach the recipients without being flagged as spam:

| Type  | Purpose                                                                                               |
| ----- | ----------------------------------------------------------------------------------------------------- |
| DMARC | Policy - what action should be taken if a email does not "pass" DKIM or SPF validation?               |
| DKIM  | Signing - each email is signed with a private key, the public key is put in DNS for the sender domain |
| SPF   | Authorize email servers - what servers (source IPs) are allowed to send emails for this domain name   |

## Additional reading

External resources that explains how DMARC, DKIM and SPF works:

- [Cloudflare - What is a DNS DMARC record?](https://www.cloudflare.com/learning/dns/dns-records/dns-dmarc-record/)
- [Cloudflare - What is a DNS DKIM record?](https://www.cloudflare.com/learning/dns/dns-records/dns-dkim-record/)
- [Cloudflare - What is a DNS SPF record?](https://www.cloudflare.com/learning/dns/dns-records/dns-spf-record/)

