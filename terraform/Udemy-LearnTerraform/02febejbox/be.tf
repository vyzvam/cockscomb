
resource "azurerm_resource_group" "be-rg" {
  name     = var.be-rg.name
  location = var.location-name
  tags = {
    Billing    = "internal"
    Department = "601 Cloud Operations"
  }
}

resource "azurerm_virtual_network" "be-rg" {
  name                = "web-vnet"
  address_space       = ["10.0.2.0/23"]
  location            = azurerm_resource_group.be-rg.location
  resource_group_name = azurerm_resource_group.be-rg.name
  tags = {
    Billing    = "internal"
    Department = "601 Cloud Operations"
  }
}

resource "azurerm_subnet" "be-rg-01" {
  name                 = "web-subnet"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = azurerm_resource_group.be-rg.name
  virtual_network_name = azurerm_virtual_network.be-rg.name
}

resource "azurerm_network_interface" "be-rg" {
  name                = "web-nic"
  location            = azurerm_resource_group.be-rg.location
  resource_group_name = azurerm_resource_group.be-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.be-rg-01.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "be-rg" {
  name                = "ssubweb-nsg"
  location            = azurerm_resource_group.be-rg.location
  resource_group_name = azurerm_resource_group.be-rg.name
}

resource "azurerm_network_security_rule" "be-rg" {
  name                        = "web"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "${azurerm_network_interface.be-rg.private_ip_address}/32"
  resource_group_name         = azurerm_resource_group.be-rg.name
  network_security_group_name = azurerm_network_security_group.be-rg.name
}

resource "azurerm_network_interface_security_group_association" "be-rg" {
  network_interface_id      = azurerm_network_interface.be-rg.id
  network_security_group_id = azurerm_network_security_group.be-rg.id
}

resource "azurerm_virtual_machine" "be-rg" {
  name                  = "web-vm01"
  location              = azurerm_resource_group.be-rg.location
  resource_group_name   = azurerm_resource_group.be-rg.name
  network_interface_ids = [azurerm_network_interface.be-rg.id]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "web-osdisk"
    managed_disk_type = "StandardSSD_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }


  os_profile {
    computer_name  = "web-vm01"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }

}

resource "azurerm_virtual_machine_extension" "be-rg" {
  name                 = "iis_extension"
  virtual_machine_id   = azurerm_virtual_machine.be-rg.id
  publisher            = "Microsoft.Computer"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
    {
      "commandToExecute": "powershell Install-WindowsFeatures -name Web-Server -IncludeManagementTools;"
    }
    SETTINGS
}


