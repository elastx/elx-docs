---
title: "Announcements"
description: "Mail Relay service announcements"
---

## 2025-01-08 DKIM signing now required for all mail relay customers
### Breaking changes
All mail relay customers are now **required** to implement DKIM signing for the domains they wish to use with our mail relay service. This can be as simple as adding a DNS record, please contact our support to get started. From **2025-04-01** our Mail Relay service will reject mails from domains without DKIM configured.

### Background
Forged addresses and content are widely used in spam, phishing and other email frauds. To protect legitimate organisations and end users, more and more email providers are starting to reject mail sent without a valid DKIM signature.

DKIM adds a digital signature to an outgoing message. The receiver can, using this digital signature, verify that an email coming from a specific domain was indeed authorized by the owner of that domain. Usually this verification is done automatically by the receiving mail server and is transparent to end-users.

### Impact
> From 2025-04-01 we will not accept sender domains without DKIM configured.

If you are already using our DKIM signing service there is no action needed. If you have any questions or want to set up DKIM signing for your domains, please register a support ticket at https://support.elastx.se/.


## 2024-05-01 DKIM signing service now available
We now offer DKIM signing on emails sent through our mail relay.


### What's new?
Previously the only option for DKIM signed messages sent through our mail relay was to sign the emails before sending them to us. This is still a viable option in case you want to control the key used for signing. As an alternative to the above, you can now contact us to request that Elastx mail relay handles DKIM signing for you.


### Background
DKIM adds a digital signature to an outgoing message. Receiving mail servers can, using this digital signature, verify that a message did originate from a trusted source for the sender domain.

Spam and phishing attempts are such a big problem in the industry today that unsigned emails are much more likely to be marked as spam, subject to heavy rate-limits, and/or outright refused on the receiving end.


### Impact
There is no impact if you already sign your messages before sending them to our mail relay.

We heavily recommend all customers not already signing their messages, to use our DKIM signing. All mail sent through our mail relay service will be forced to carry a DKIM signature at a future unenclosed date.

If you have any general questions or would like to sign-up please contact us at hello@elastx.se. For any technical questions please register a support ticket at https://support.elastx.se.
