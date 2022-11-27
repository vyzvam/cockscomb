# Identity & Access - Hybrid Identity solution

## Hybrid Identity solutions

It is used for organizations with mix of on prem and cloud based environments
On premise AD <-> AAD

### Active Directory Federation Service (ADFS)

ADFS is installed on on prem server , integrated in to AD and configure 'Federation trust' to talk to AAD.

### Azure AD Connect

OnPrem AD connected to a Azure AD Connect server (provisioned as part of the on prem domain).
used to establish a connection to AAD.

* Federated integration - configure hybrid ENV using onprem AD federation service infra.
* Health Monitoring - Monitoring of the AZ AD Connect sync service, onprem AD services and ADFS

There are 2 synch techniques

### Password hash syncronization

hash of the hash of users passwords from the onprem AD are copied to the cloud based AAD instance.
The same password can be used for both onprem and cloud based envinronment.

#### Pass-through authentication

Allow users to sign-in via their onprem AD

#### Password writeback

allows password reset or change that will update the password in onprem AD

##### Passwordless authentication

3 mechanism available

* Windows hello for business
* MS Authenticator App
* FIDO2 security keys

Goto AAD->Security->Authentication methods.









