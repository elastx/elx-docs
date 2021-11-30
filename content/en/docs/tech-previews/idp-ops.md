---
title: "Elastx Identity"
weight: 1
alwaysopen: true
---

The purpose of Elastx Identity is to provide a Single Sign-on experience
for access to the different Elastx service offerings. Available as a tech
preview, the service provides integration with
[OpenStack IaaS](https://elastx.se/en/openstack) to enable usage/enforcement
of multi-factor authentication.


## Join tech preview
If your organization is interested in taking part of the tech preview,
submit a request through the [Elastx Support page](https://support.elastx.se).
   
Once enrolled, all or selected users will receive an email to verify
their account and setup multi-factor authentication.  
  
Before joining the tech preview, please review
[known issues and limitations](#known-issueslimitations).


## Update account settings
Users in organizations which have enrolled for tech preview can use the
["My Account" web page](https://auth.elastx.cloud/my_account) to change
their password, configure multi-factor authentication and similar account
related settings.


## Supported MFA methods
In addition to username and password for authentication, the tech preview
provides the ability to configure multi-factor authentication using either
TOTP, supported by mobile applications such as "Google Authenticator" and
"[FreeOTP](https://freeotp.github.io/)"), or the Webauthn standard which
enables usage of hardware tokens such as the Yubikey.


## OpenStack authentication flow
Once enrolled in the tech preview, users can login to the
[OpenStack web dashboard (Horizon)](https://ops.elastx.cloud) by selecting
"elastx-id" in the "Authenticate using" drop-down menu and pressing "Connect":

![Horizon login page](/img/idp_login-1.png)

The users are redirected redirected to the login portal, which validates their
password/second-factor and redirects them back to the OpenStack dashboard.

![Login portal: Username and password](/img/idp_login-2.png)
![Login portal: Second-factor](/img/idp_login-3.png)


## Known issues/limitations
During the tech preview phase, the OpenStack platform is configured to support
authentication and account management using both platform-specific features
(Keystone/Adjutant) and those provided by the Elastx identity service.  
  
This configuration enables users to join/leave the tech preview and still
interoperate with each other. As a consequence, it does however affect some
functionality that may not work as expected for users in the tech preview.  
  
The following sections describe known issues, limitations and relevant
workarounds.


### CLI and Terraform usage 
Applications that use the OpenStack APIs directly, such as the official CLI
utilities, Terraform and similar automation tools, do not support
authentication using the identity provider. For these use-cases, a dedicated
service account or usage of
[application credentials](/docs/openstack-iaas/guides/application_credentials/)
is highly recommended.  
  
In order to create application credentials, direct usage of the APIs
or the "openstack" CLI utility is required. This means that the application
credentials must be generated before the user account is enrolled for the tech
preview. The issue will however be resolved after the next upgrade of OpenStack
(planned Q1 2022), as a feature has been implemented to generate and download
application credentials through the OpenStack web dashboard.


### Logout functionality in Horizon
Once a user who has authenticated through the Elastx Identity service logs out
of the OpenStack web dashboard (Horizon), their browser session token remains
valid for a short period of time. This issue has been mitigated in later
versions of OpenStack and the only currently available work-around is to
manually clear all browser cookies for the "ops.elastx.cloud" origin.


### User settings and project management
Users enrolled for the tech preview can not utilize functionality exposed
through the OpenStack web dashboard for account management, such as
change/reset password features. These actions may instead be performed through
the ["My Account" web page](https://auth.elastx.cloud/my_account).  
  
While the ability for project moderators to invite other users to their
projects still exist, it should be noted that new users won't be automatically
enrolled in the tech preview.
