# Define Terraform provider
terraform {
  required_version = ">= 0.12"
  backend "azurerm" {
    resource_group_name  = "ssub-tfstate-rg"
    storage_account_name = "ssubcloudtfstate"
    container_name       = "core-tfstate"
    key                  = "core.ssub.tfstate"
  }
}

# Configure the Azure provider
provider "azurerm" {
  environment = "public"
}


# provider "azurerm" {
#   subscription_id = var.azure-subscription-id
#   client_id       = var.azure-client-id
#   client_secret   = var.azure-client-secret
#   tenant_id       = var.azure-tenant-id
# }