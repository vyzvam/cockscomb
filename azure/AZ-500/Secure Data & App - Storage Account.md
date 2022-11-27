# Secure Data & App - Storage Account

## Access Control

### Using access keys

complete control over all services in a storage account

Goto->The storage account->Settings->Access Keys

Observe there are Key1, Key2

You can use the Key values to connection to the storage account.

The keys can be manually regenerated from the portal.

#### Using Keyvault to manage key regenaration

first assign the role 'Storage account key operator service role to the keyvault to access the storage account

```c#
az role assignment create --role "Storage Account Key Operator Service Role" --assignee-object-id <the_keyvault_object_id>
--scope '/subscriptions/<subscriptionid>/resourceGroups/<resourcegroup>/providers/Microsoft.Storage/storageAccounts/<storageaccountname>'

az keyvault set-policy  --name <vaultname> objecti-id <idoftheuser> --storage-permission set get regeneratekey

az keyvault storage add --vault-name <keyvault> -n <storageaccount> --active-key-name key1 --auto-regenerate-key
--regeneration-period P90D --resource-id "/subscription/<subscriptionid>/resourceGroups/<resourcegroup>/providers/Microsoft.Storage/storageAccounts/<storageaccount>"

```

### Anonymous public read access

Available for containers and blobs

### Shared Key

Construct the shared key and pass it in the header with every request to the storage account.

### Shared access signature (SAS)

Provides limited access to resources in storage account.
Used to grant secure access to the storage account without compromising storage account keys.
Can define permission on resources with the help of SAS and define expiry of the access
Can define SAS as account and blob level.

Goto->The storage account->containers->blob object->Generate SAS
specify, permssion, duration, allowed ip address, allowed protocol & signing key.
Click generate SaaS token and url.

you can set the SaaS for the storage account at the Settings->Shared access signature blade
You can select Blob/File/Queue/Table.

#### Stored access policies (SAP)

Access policies can be set in the containers->Settings->Access policy.
You can generate the SAS based on the access policy from the storage exploer application.
The advantage of access policy is that you can modify the access policy after the SAS is generated.



### Azure AD integration

Available for blobs and queues

### Azure AD Domain Services integartion

Available for files

Steps:

* Create a new instance of AAD Domain Services.
  * register a domain and create an AAD Domain services
  * user must be part of the AAD DC Administrators group
* Enable AAD Domain services for the desired Azure virtual network.
  * create an vnet where custom DNS Servers is configured.
* Domain to join the virtual machine to access files share from the VM.
  * Create and add a VM to the vnet
  * Within the VM, ensure is part of the domain.
* Enable AAD Domain services integration for the storage account.
  * IN the storage account configuration, Select "AAD Domain services (Azure AD DS)" in the Identity-based Directory service for Azure file authentication.

* Set the required role based permissions
  * in Access Control, add role assignment, 3 options available
    * Storage File Data SMB Share Contributor
    * Storage File Data SMB Share Elevated Contributor
    * Storage File Data SMB Share Reader
* Set the required NTFS permissions.
  * In the VM, on the mapped drive assign users who are part of the ad group



