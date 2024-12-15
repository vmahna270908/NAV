#Data for the Resource Group
data "azurerm_resource_group" "Dev-RG" {
  name = "Dev-RG"
}

resource "azurerm_network_interface" "" {
  name                = var.JumpServer1_NIC
  location            = data.azurerm_resource_group.Dev-RG.location
  resource_group_name = data.azurerm_resource_group.Dev-RG.name

  ip_configuration {
    name                          = "JumpServer1"
    subnet_id                     = azurerm_subnet.AZ-NAV-vNet-LB.id
    private_ip_address_allocation = "Dynamic"
  }
}