#Azure Provider source and version being used
##
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.33.0"
    }
  } 
}

# Configure the backend for storing Terraform state
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatestoragecloud"
    container_name       = "tfstate"
    key                  = "nav.tfstate"
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}