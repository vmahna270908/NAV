#Azure Provider source and version being used
##
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
  location = "Canada Central"
}

#vNet Creation for the Dev-RG Resource Group
resource "azurerm_virtual_network" "NAV_vNet" {
  name                = var.NAV_vnet_Name
  location            = data.azurerm_resource_group.Dev-RG
  resource_group_name = data.azurerm_resource_group.Dev-RG
  address_space       = var.NAV_vNet_Address_Space
  tags = {
  type = "vNet"
  RG ="Dev-RG"
  project = "NAV"
  }
}

