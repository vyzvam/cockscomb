# Configure the Azure Provider
provider "azurerm" {
  version = "=2.0.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "caapj-terra01" {
  name     = "caapj-terra01"
  location = "East US"
}

