#Azure Provider source and version being used
#
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"
    }
  }
  backend "azurerm" {
  }   
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

#Data for the Resource Group
data "azurerm_resource_group" "Dev-RG" {
  name = "Dev-RG"
}

#vNet Creation for the Dev-RG Resource Group
resource "azurerm_virtual_network" "NAV_vNet" {
  name                = var.NAV_vnet_Name
  location            = azurerm_resource_group.Dev-RG.location
  resource_group_name = azurerm_resource_group.Dev-RG.name
  address_space       = var.NAV_vNet_Address_Space
  tags = {
  type = "vNet"
  RG ="Dev-RG"
  project = "NAV"
  }
}

#Subnet Creation
resource "azurerm_subnet" "Subnet1" {
  name                 = "Subnet-NAV_vNet-1"
  resource_group_name  = azurerm_resource_group.Dev-RG.name
  virtual_network_name = azurerm_virtual_network.NAV_vNet
  address_prefixes     = ["10.0.1.0/25"]
}