
resource "azurerm_resource_group" "jbox-rg" {
  name     = "jbox-rg"
  location = "West Europe"
  tags = {
    Billing    = "internal"
    Department = "601 Cloud Operations"
  }
}

resource "azurerm_network_interface" "jbox-rg" {
  name                = "jbox-nic"
  location            = azurerm_resource_group.jbox-rg.location
  resource_group_name = azurerm_resource_group.jbox-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.fe-rg-02.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "jbox-rg" {
  name                = "ssubjbox-nsg"
  location            = azurerm_resource_group.be-rg.location
  resource_group_name = azurerm_resource_group.be-rg.name
}

resource "azurerm_network_security_rule" "jbox-rg" {
  name                        = "rdp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "${azurerm_network_interface.jbox-rg.private_ip_address}/32"
  resource_group_name         = azurerm_resource_group.jbox-rg.name
  network_security_group_name = azurerm_network_security_group.jbox-rg.name
}

resource "azurerm_network_interface_security_group_association" "jbox-rg" {
  network_interface_id      = azurerm_network_interface.be-rg.id
  network_security_group_id = azurerm_network_security_group.be-rg.id
}

resource "azurerm_virtual_machine" "jbox-rg" {
  name                  = "web-vm01"
  location              = azurerm_resource_group.jbox-rg.location
  resource_group_name   = azurerm_resource_group.jbox-rg.name
  network_interface_ids = [azurerm_network_interface.jbox-rg.id]
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