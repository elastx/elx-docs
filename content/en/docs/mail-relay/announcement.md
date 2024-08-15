---
title: "Announcements"
description: "Mail Relay service announcements"
---

## 2024-05-01 DKIM signing service now available
We now offer DKIM signing on emails sent through our mail relay.


**What's new?**<br />
Previously the only option for DKIM signed messages sent through our mail relay was to sign the emails before sending them to us. This is still a viable option in case you want to control the key used for signing. As an alternative to the above, you can now contact us to request that Elastx mail relay handles DKIM signing for you.


**Background**<br />
DKIM adds a digital signature to an outgoing message. Receiving mail servers can, using this digital signature, verify that a message did originate from a trusted source for the sender domain.

Spam and phishing attempts are such a big problem in the industry today that unsigned emails are much more likely to be marked as spam, subject to heavy rate-limits, and/or outright refused on the receiving end.


**Impact**<br />
There is no impact if you already sign your messages before sending them to our mail relay.

We heavily recommend all customers not already signing their messages, to use our DKIM signing. All mail sent through our mail relay service will be forced to carry a DKIM signature at a future unenclosed date.

If you have any general questions or would like to sign-up please contact us at hello@elastx.se. For any technical questions please register a support ticket at https://support.elastx.se.
