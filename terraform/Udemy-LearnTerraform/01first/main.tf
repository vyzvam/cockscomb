provider "azurerm" {
  # source = "hashicorp/azurerm"
  version = "~>2.45.1"
  features {}
}


data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "ssub-terra-rg"
  location = "West Europe"
  tags = {
    Billing    = "internal"
    Department = "601 Cloud Operations"
  }
}

resource "azurerm_key_vault" "kv" {
  name                = "ssub-kv-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags = {
    Billing    = "internal"
    Department = "601 Cloud Operations"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "ssubsa01"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "standard"
  account_replication_type = "LRS"
  tags = {
    Billing    = "internal"
    Department = "601 Cloud Operations"
  }
}