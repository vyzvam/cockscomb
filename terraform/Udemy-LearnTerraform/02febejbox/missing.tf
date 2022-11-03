resource "azurerm_virtual_network_peering" "fe-be" {
  name                      = "fe-be"
  resource_group_name       = azurerm_resource_group.fe-rg.name
  virtual_network_name      = azurerm_virtual_network.fe-rg.name
  remote_virtual_network_id = azurerm_virtual_network.be-rg.id
}

resource "azurerm_virtual_network_peering" "be-fe" {
  name                      = "be-fe"
  resource_group_name       = azurerm_resource_group.be-rg.name
  virtual_network_name      = azurerm_virtual_network.be-rg.name
  remote_virtual_network_id = azurerm_virtual_network.fe-rg.id
}

resource "azurerm_firewall_nat_rule_collection" "fe-rg" {
  name                = "net-rules"
  azure_firewall_name = azurerm_firewall.fe-rg.name
  resource_group_name = azurerm_resource_group.fe-rg.name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "webrule"
    source_addresses = [
      "*"
    ]
    destination_addresses = [
      azurerm_public_ip.fe-rg.ip_address
    ]
    destination_ports = [
      "80"
    ]
    translated_port    = 80
    translated_address = azurerm_network_interface.be-rg.private_ip_address
    protocols = [
      "TCP"
    ]

  }
  rule {
    name = "jboxrule"
    source_addresses = [
      "*"
    ]
    destination_addresses = [
      azurerm_public_ip.fe-rg.ip_address
    ]
    destination_ports = [
      "3389"
    ]
    translated_port    = 3389
    translated_address = azurerm_network_interface.jbox-rg.private_ip_address
    protocols = [
      "TCP"
    ]

  }

}

resource "azurerm_network_security_rule" "be-rg-01" {
  name                        = "rdp"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "${azurerm_network_interface.jbox-rg.private_ip_address}/32"
  destination_address_prefix  = "${azurerm_network_interface.be-rg.private_ip_address}/32"
  resource_group_name         = azurerm_resource_group.jbox-rg.name
  network_security_group_name = azurerm_network_security_group.jbox-rg.name
}