# Terraform and Azure
https://gmusumeci.medium.com/getting-started-with-terraform-and-microsoft-azure-a2fcb690eb67


## Prerequisites
* Terraform installed
* VS Code
* VS Code Extension: Azure Terraform
* Logged in to Azure


## Create service principal
```c#
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/a58f4f07-6319-4d8a-b908-1e047d2fd178" --name "ssub-terraform"

//output
{
  "appId": "17a303ab-0205-4bd4-bbf2-bf56f32967f7",
  "displayName": "ssub-terraform",
  "name": "http://ssub-terraform",
  "password": "tCEpsY_I5-TjcIgDsTKi4wlByKPpd8o6VJ",
  "tenant": "91700184-c314-4dc9-bb7e-a411df456a1e"
}
```

## Create terraform variables

Create a variables file `variables.tf` containing
```c#
#Azure Subscription Id
variable "azure-subscription-id" {
    type = string
    description = "Subscription Id"
}

#Azure Client Id/aapid
variable "azure-client-id" {
    type = string
    description = "Client Id"
}

#Azure Client Id/aapid
variable "azure-client-secret" {
    type = string
    description = "Client Id"
}

#Azure Tenant Id
variable "azure-tenant-id" {
    type = string
    description = "Tenant Id"
}

```
## Create `terraform.tfvars`

```c#
# Azure Subscription Id
azure-subscription-id = "a58f4f07-6319-4d8a-b908-1e047d2fd178"
# Azure Client Id/appId
azure-client-id = "17a303ab-0205-4bd4-bbf2-bf56f32967f7"
# Azure Client Secret/password
azure-client-secret = "tCEpsY_I5-TjcIgDsTKi4wlByKPpd8o6VJ"
# Azure Tenant Id
azure-tenant-id = "91700184-c314-4dc9-bb7e-a411df456a1e"
```

## Create storage account to store the terraform state file

```c#

RESOURCE_GROUP_NAME=kopicloud-tstate-rg
STORAGE_ACCOUNT_NAME=kopicloudtfstate$RANDOM
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location "southeastasia"

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
```