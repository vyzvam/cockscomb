

resource "azurerm_resource_group" "fe-rg" {
  name     = "fe-rg"
  location = "West Europe"
  tags = {
    Billing    = "internal"
    Department = "601 Cloud Operations"
  }
}

resource "azurerm_virtual_network" "fe-rg" {
  name                = "fe-vnet"
  address_space       = ["10.0.0.0/23"]
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name
  tags = {
    Billing    = "internal"
    Department = "601 Cloud Operations"
  }
}

resource "azurerm_subnet" "fe-rg-01" {
  name                 = "AzureFirewallSubnet"
  address_prefixes     = ["10.0.0.0/24"]
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
}

resource "azurerm_subnet" "fe-rg-02" {
  name                 = "jbox-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
}

resource "azurerm_public_ip" "fe-rg" {
  name                = "pub_ip01"
  resource_group_name = azurerm_resource_group.fe-rg.name
  location            = azurerm_resource_group.fe-rg.location
  allocation_method   = "Static"
  sku                 = "standard"
  tags = {
    Billing    = "internal"
    Department = "601 Cloud Operations"
  }
}

resource "azurerm_firewall" "fe-rg" {
  name                = "fw_01"
  resource_group_name = azurerm_resource_group.fe-rg.name
  location            = azurerm_resource_group.fe-rg.location

  ip_configuration {
    name                 = "fwip_config"
    subnet_id            = azurerm_subnet.fe-rg-01.id
    public_ip_address_id = azurerm_public_ip.fe-rg.id
  }
}





