# Configure the Azure Provider
provider "azurerm" {
  version = "=2.0.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "ssub-ex01" {
  name     = "ssub-ex01"
  location = "East US"
}

