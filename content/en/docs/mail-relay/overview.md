---
title: "Mail Relay"
description: "Using Elastx as a Mail Relay"
weight: 1
alwaysopen: true
---

When using the Elastx Mail Relay service it is important that you have the following:

 * Username and Password provided by Elastx
 * Included Elastx Mail Relay in your sender domain's Sender Policy Framework (SPF)
 * Added the `elastx-mrs` DNS challenge token to your sender domain's DNS records

Elastx Mail Relay is availabe using the following specifications:

| Property | Value |
|----------|------------------------------------|
| Server   | smtp.elastx.email
| Port     | 587
| Protocol | SMTP + STARTTLS (preferred)


## Setting up Sender Policy Framwork (SPF)

Setting up a correct SPF record for the domain you send e-mails from is paramount.
Elastx Mail Relay will check that SPF has been configured before allowing an email
to be sent.

### Background

When e-mail was first created it allowed for e-mails to be sent from anyone
to anyone without any form of authenticity checking. This is one of the reasons
we have a lot of Spam e-mails today. SPF was invented to help solving this issue
and is used to ensure that emails originate from authorized sources.

In order to protect citizens on the Internet from Spam, Elastx Mail Relay will
only allow transmission of e-mails that specifically whitelist the service as
an authorized sender.

### Set-up

For a domain that has no previous SPF record you can simply add a new TXT
record with the content `v=spf1 include:elastx.email -all`.

To check your domains' SPF record you can either use the `dig -t TXT` Linux
command or a website such as
[Google Admin Toolbox](https://toolbox.googleapps.com/apps/dig/#TXT/).

A correct result must include the exact string `include:elastx.email`.

**Note:** Elastx Mail Relay does not support checking of sub-includes -
the `include:elastx.email` has to be present on the domain itself.

### Example 1

You have been given an account named `steve.mailer@mycorp.se` with a password and
you wish to send the company newsletter from `newsletter@mycorp.se`.

Since in this case the company likely is already sending e-mails on the domain
`mycorp.se` it is likely there is already an SPF record present. You will have
to modify the already present SPF record as described above.

### Example 2

You have been given an account named `steve.mailer@mycorp.se` with a password and
you wish to send the company newsletter from `newsletter@new.mycorp.se`.

In this case it is important to note that even though the username and password
to the relay service is `mycorp.se`, the domain that needs to be configured
is `new.mycorp.se`. The username is fully separate and there is no need to
do any SPF configuration on the domain associated with the username - unless it
is also the domain you are trying to send e-mails from of course.

In this case `new.mycorp.se` is likely a new sub-domain and you should proceed
adding a new SPF record like described above.

## Setting up the Elastx Mail Relay DNS challenge token

While SPF is a standarized procedure that all mail relays require, the
DNS challenge token is specific for the Elastx Mail Relay.

### Background

The Elastx Mail Relay serves many customers at the same time and needs a way
to ensure that its customers cannot send e-mails on eachother's behalf.

This is why the DNS challenge token is required.

### Set-up

The DNS challenge token is very similar to SPF in that it is configured on
exactly the same place as you put your SPF record, and it is also a TXT record.

The format of the TXT record is `elastx-mrs=[SHA256 of mail relay username]`.

On a Linux system it can be generated like this:

```
echo "elastx-mrs=$(echo -n "steve.mailer@mycorp.se" | sha256sum | cut -d ' ' -f 1)"
```

