---
title: "Overview"
weight: 1
alwaysopen: true
---

The purpose of Elastx Identity Provider (IDP) is to provide a Single Sign-on
experience for access to the different Elastx service offerings. The service 
provides integration with [OpenStack IaaS](https://elastx.se/en/openstack) to
enable usage/enforcement of multi-factor authentication.


## Enrollment
Once enrolled, all or selected users will receive an email to verify
their account and setup multi-factor authentication.  
  
Please review [known issues and limitations](#known-issueslimitations) for 
further reference.


## Update account settings
Users in organizations which have enrolled can use the ["My Account" web page](https://auth.elastx.cloud/my_account) to change their password, configure multi-factor authentication and 
similar account related settings.


## Supported MFA methods
In addition to username and password for authentication, the ability to configure
multi-factor authentication using either TOTP, supported by mobile applications
such as "Google Authenticator" and "[FreeOTP](https://freeotp.github.io/)"), or
the Webauthn standard which enables usage of hardware tokens such as the Yubikey.  
  
TOTP is default method for all accounts (except if explicitly defined otherwise
for the organization), but can be changed by the user after initial setup.


## OpenStack authentication flow
Once enrolled users can login to the [OpenStack web dashboard (Horizon)](https://ops.elastx.cloud) by selecting "elastx-id" in the "Authenticate using" drop-down menu and pressing "Connect":

![Horizon login page](/img/idp_login-1.png)

The users are redirected redirected to the login portal, which validates their
password/second-factor and redirects them back to the OpenStack dashboard.

![Login portal: Username and password](/img/idp_login-2.png)
![Login portal: Second-factor](/img/idp_login-3.png)


## Known issues/limitations
The OpenStack platform is configured to support authentication and account 
management using both platform-specific features (Keystone/Adjutant) and those 
provided by IDP.    
  
The following sections describe known issues, limitations and relevant
workarounds.


### Mandatory usage of MFA
All users enrolled are required to configure both a password and a second factor
for authentication. Enforcement of MFA for all non-services users is planned.


### CLI and Terraform usage 
Applications that use the OpenStack APIs directly, such as the official CLI
utilities, Terraform and similar automation tools, do not support
authentication using the identity provider. For these use-cases, a dedicated
service account or usage of [application credentials](/docs/openstack-iaas/guides/application_credentials/)
is highly recommended.  


### Logout functionality in Horizon
Once a user who has authenticated through the IDP logs out
of the OpenStack web dashboard (Horizon), their browser session token remains
valid for a short period of time. This issue has been mitigated in later
versions of OpenStack and the only currently available work-around is to
manually clear all browser cookies for the "ops.elastx.cloud" origin.


### User settings and project management
Users enrolled can not utilize functionality exposed through the OpenStack web
dashboard for account management, such as change/reset password features. 
These actions may instead be performed through the ["My Account" web page](https://auth.elastx.cloud/my_account).
  
While the ability for project moderators to invite other users to their
projects still exist, it should be noted that new users won't be automatically
enrolled.


### Full credential reset
Users can initiate a password reset by clicking on the "Forgot Password?" link
below the login form. The password reset flow requires that user authenticate
using their second-factor before proceeding.  
  
If the user has lost access to their second-factor (multiple can be configured
as a backup), [Elastx Support](https://support.elastx.se) must be contacted for
additional identity validation before both credentials are reset.
This process is by design for security reasons, but may be reconsidered before
the service is generally available.
