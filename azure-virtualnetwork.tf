#Data for the Resource Group
data "azurerm_resource_group" "Dev-RG" {
  name = "Dev-RG"
}

#vNet Creation for the Dev-RG Resource Group
resource "azurerm_virtual_network" "NAV_vNet" {
  name                = var.NAV_vnet_Name
  location            = data.azurerm_resource_group.Dev-RG.location
  resource_group_name = data.azurerm_resource_group.Dev-RG.name
  address_space       = var.NAV_vNet_Address_Space
  tags = {
  type = "vNet"
  RG ="Dev-RG"
  project = "NAV"
  }
}
#Subnet Creation
resource "azurerm_subnet" "AZ-NAV-vNet-MGM" {
  name                 = var.NAV_vnet_MGM_Name
  resource_group_name  = data.azurerm_resource_group.Dev-RG.name
  virtual_network_name = azurerm_virtual_network.NAV_vNet.name
  address_prefixes     = var.NAV_vNet_MGM_Address_Space
}

resource "azurerm_subnet" "AZ-NAV-vNet-LB" {
  name                 = var.NAV_vnet_LB_Name
  resource_group_name  = data.azurerm_resource_group.Dev-RG.name
  virtual_network_name = azurerm_virtual_network.NAV_vNet.name
  address_prefixes     = var.NAV_vNet_LB_Address_Space
}

resource "azurerm_subnet" "AZ-NAV-vNet-App" {
  name                 = var.NAV_vnet_App_Name
  resource_group_name  = data.azurerm_resource_group.Dev-RG.name
  virtual_network_name = azurerm_virtual_network.NAV_vNet.name
  address_prefixes     = var.NAV_vNet_App_Address_Space
}

resource "azurerm_subnet" "AZ-NAV-vNet-SQL" {
  name                 = var.NAV_vnet_SQL_Name
  resource_group_name  = data.azurerm_resource_group.Dev-RG.name
  virtual_network_name = azurerm_virtual_network.NAV_vNet.name
  address_prefixes     = var.NAV_vNet_SQL_Address_Space
}