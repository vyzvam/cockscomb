# Secure Data & App - KeyVault

## General

* Used to securely store and access secrets, these are API Keys, passwords or certificates.
* Can set access permissions to SPs for the secrets, keys & certificates. Different permissions are available
* Protect KV and it's objects using soft-delete feature where the retention period can be configured (7 to 90 days).
*

## Access policies

By default global admin has all access to the secrets, keys and certificates. but does not have cryptography related access.

There is also options for
* VM for deployments
* Resource manager for template deployments
* Disk encryption for volume encryption

### RBAC

KV also supports RBAC, to p

## Managing secrets

Secrets can be created and managed by configuring activation and expiry date
It can also be enabled/disabled.

## Storage keys rotation

Create and automation account with Create run as account enabled
Goto->TheAutomationAccount->RunAsAccount->Get the Application Id

Run the command to set the access policy

```c#
Set-AzKeyVaultAccessPolicy -VaultName <VaultName> -ServicePrincipalName <TheApplicationId> -PermissionsToSecrets Set
```

Ensure the Modules in AA is updated 
Goto Modules->Browse Gallery->(Az.Keyvault)->Import
Edit the runbook and configure the properties accordingly.
Run the runbook

## Backup & Restore

Can create offline copy of the secrets, the backup operations will download the object as an encrypted blob

To restore, the target KV must be in the same subscription and region, paired-region.

## Firewall and network security

Can configure to add A VNet & Service endpoints (keyvault) where other resources reside, such as a VM, and the VM can have access to the KV

