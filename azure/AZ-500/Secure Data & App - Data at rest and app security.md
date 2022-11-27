# Secure Data & App - Data at rest and app security

## Azure Sql Database - Dynamic data masking

A technique to limit the exposure of a senstitive data to a non-privileged user.
Can configure level of expose of data.

Type of masking

* Default - full masking
* Credit card - only the last 4 digits are shown.
* Email - exposes first letter and the domain name is masked
* Random number
* Custom text


### Howto - DDM

Goto->TheDatabase->Security->Dynamic data masking->Add a mask

* Select schema, table & Column
* Select how to mask

## Protecting SQL data by encryption

### Transparent data encryption

* Protect data at rest for an Azure SQL Database.
* Data, backups & transactin log files are encrypted at rest
* By default, uses the database encryption key that is protected by a built-in server certificate
* the certificate is different for every server
* Can user customer-managed keys for encryption, by using Azure KeyVault service.

#### Howto

Goto->TheSqlDatabase->Security->Transparent data encryption->Data encryption->On



### Always encrypted feature

* Protect sensitive data at rest on server, when data is moved between the client and the server and when the data is in use.
* Keys are used to encrypt. Only client app or appservers that have access to the key will be able to see the data in plaintext.
* 2 keys are used, Column encryption key to encrypt the data & Column master key are key-protecting keys to encrypt the column encryption keys
* Keys need to be stored in a trusted key store such as windows certificate store or azure key vault service.

#### 2 types of encryption is used

* Determenistic encryption - Always generate the same encrypted value for any plain text value. You can perform point lookups, equality joins and indexing
* Randomized encryption - More secure, But can't perform search, grouping, indexing or joins

#### Howto

Goto->TheKeyVault->Access Policies->Set key access policy for the user
Decrypt, Encrypt, Unwrap, wrap, verify & Sign

Goto->TheDatabase->Overview->Set server firewall
Allow azure services and resoures to access this server

Goto->SQLManagementStudio->LoginToSQLServer
Select Database->Choose Encrypt columns->Choose columns->Choose type of encryption->select key store provider->Azure Key vault->Done

## SQL Database firewall & network security

Goto->TheSqlServer->Security->Firewalls and VNets->Add client IP

Goto->TheVNet(that hosts the VM)->Setting->Service endpoints->Add->Microsoft.Sql->Choose subnet
Goto->TheSqlServer->Security->Firewalls and VNets->Add existing VNet->Add the VNet

## Azure storage Encryption

* They are automatically encrypted at rest.
* Encrypy/decrypt transparently using 256-bit AES
* Cant' be disabled, no performance impact and no additional cost
* Carried out using Microsoft managed keys.
* Can use customer-managed keys using Keyvault but only for blog and file

### Howto customer-managed keys

Goto->StorageAccount->Encryption->Choose Customer managed keys-> Select KV & encryption key

## Azure VM disk encryption

Bitlocker is used to encrypt OS & Disk for Windows
Suported windows client 8 and later, windows server 2008 R2 and later
CM-Crypt is used to encrypt OS & Disk for Linux
Can use Azure KV to store the encryption keys.


### Howto

Goto->TheKV->Acess policies->Azure disk encryption for volume encription->enabled

Issue the command below

```c#
az vm encription enable -g <rg> --name <vmname> --disk-encryption-keyvault <keyvaultname>

```

## Web app security

* Usage of static IP restriction - Define a list of IP addressess that are allowed to access the app service.
* Can use the isolated pricing tier since it runs in a completely isolated network.
* Hybrid connection or Vnet integration to secure connection when accessing Vnets or onprem resources.
* Define ENV variables via the app settings and connection strings.which are encrypted 
* To use SSL/TLS for secure connection
* redirect all http connection to HTTPS
* Disable anonymous access and enable AD authentication

### Howto

Goto->TheAppService->Settings->Configurations->(Application settings / Connection string)
Goto->TheAppService->Settings->Authetication & Authoriztion->App service authentication->ON->Choose authentication providers
Goto->TheAppService->Settings->TLS/SSL Settings->HTTPS only->ON->
Goto->TheAppService->Settings->Networking->VNet integration / Hybrid connection

















