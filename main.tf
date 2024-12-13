# Azure Provider source and version being used
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

locals {
  registration_token = azurerm_virtual_desktop_host_pool_registration_info.RegisterToken.token
}

#Create the Resource Group
resource "azurerm_resource_group" "AVD-RG" {
  name     = var.rg_name
  location = "Canada Central"
  tags = {
  type = "RG"
  RG ="AVD-RG"
  project = "AVD"
  }
}

#vNet Creation for the AVD-RG Resource
resource "azurerm_virtual_network" "AVD_vNet_1" {
  name                = var.AVD_vnet_Name
  location            = azurerm_resource_group.AVD-RG.location
  resource_group_name = azurerm_resource_group.AVD-RG.name
  address_space       = var.AVD_vNet_Address_Space
  tags = {
  type = "vNet"
  RG ="AVD-RG"
  project = "AVD"
  }
}

#vNet 2 Creation for the AVD-RG Resource
resource "azurerm_virtual_network" "AVD_vNet_2" {
  name                = var.AVD_vnet_Name_2
  location            = azurerm_resource_group.AVD-RG.location
  resource_group_name = azurerm_resource_group.AVD-RG.name
  address_space       = var.AVD_vNet_Address_Space_2
  tags = {
  type = "vNet"
  RG ="AVD-RG"
  project = "AVD"
  }
}

#Network Peering
resource "azurerm_virtual_network_peering" "vNet12" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.AVD-RG.name
  virtual_network_name      = azurerm_virtual_network.AVD_vNet_1.name
  remote_virtual_network_id = azurerm_virtual_network.AVD_vNet_2.id
}

resource "azurerm_virtual_network_peering" "vNet21" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.AVD-RG.name
  virtual_network_name      = azurerm_virtual_network.AVD_vNet_2.name
  remote_virtual_network_id = azurerm_virtual_network.AVD_vNet_1.id
}

#Subnet Creation
resource "azurerm_subnet" "Subnet1" {
  name                 = "Subnet-AVD_vNet-1"
  resource_group_name  = azurerm_resource_group.AVD-RG.name
  virtual_network_name = azurerm_virtual_network.AVD_vNet_1.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_subnet" "Subnet2" {
  name                 = "Subnet-AVD_vNet-2"
  resource_group_name  = azurerm_resource_group.AVD-RG.name
  virtual_network_name = azurerm_virtual_network.AVD_vNet_2.name
  address_prefixes     = ["10.0.1.128/26"]
}

#Create the Host Pool for the AVD
resource "azurerm_virtual_desktop_host_pool" "HostPool" {
  location            = azurerm_resource_group.AVD-RG.location
  resource_group_name = azurerm_resource_group.AVD-RG.name
  name                     = "avdhostpool"
  friendly_name            = "avdhostpool"
  validate_environment     = true
  start_vm_on_connect      = true
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  description              = "Acceptance Test: A pooled host pool - pooledbreadthfirst"
  type                     = "Pooled"
  maximum_sessions_allowed = 5
  load_balancer_type       = "BreadthFirst"
  tags = {
  type = "Host Pool"
  RG ="AVD-RG"
  project = "AVD"
  }
  }

  #Creating the Application Group
  resource "azurerm_virtual_desktop_application_group" "RemoteAppGroup" {
  name                = "RemoteAppGroup"
  location            = azurerm_resource_group.AVD-RG.location
  resource_group_name = azurerm_resource_group.AVD-RG.name

  type          = "RemoteApp"
  host_pool_id  = azurerm_virtual_desktop_host_pool.HostPool.id
  friendly_name = "RemoteAppGroup"
  description   = "Acceptance Test: An application group"
  tags = {
  type = "Application Group"
  RG ="AVD-RG"
  project = "AVD"
  }
}

#Creating the AVD Workspace 
resource "azurerm_virtual_desktop_workspace" "AVD-Workspace" {
  name                = "AVD-Workspace"
  location            = azurerm_resource_group.AVD-RG.location
  resource_group_name = azurerm_resource_group.AVD-RG.name

  friendly_name = "AVD-Workspace"
  description   = "Workspace for the AVD POC"
  tags = {
  type = "Workspace"
  RG ="AVD-RG"
  project = "AVD"
  }
}

#Workspace and Application Group Integration
resource "azurerm_virtual_desktop_workspace_application_group_association" "workspaceremoteapp" {
  workspace_id         = azurerm_virtual_desktop_workspace.AVD-Workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.RemoteAppGroup.id
}

#Registeration Token for the HostPool
resource "azurerm_virtual_desktop_host_pool_registration_info" "RegisterToken" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.HostPool.id
  expiration_date = "2024-10-15T23:40:52Z"
}

#Create the NIC for the AVD-VM1
resource "azurerm_network_interface" "AVD-NIC1" {
  name                = "AVD-VM-NIC1"
  location            = azurerm_resource_group.AVD-RG.location
  resource_group_name = azurerm_resource_group.AVD-RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.PublicIP1.id
  }
}

#Windows 11 Multi-Session for the AVD
resource "azurerm_windows_virtual_machine" "AVD-VM1" {
  name                = "AVD-VM1"
  resource_group_name = azurerm_resource_group.AVD-RG.name
  location            = azurerm_resource_group.AVD-RG.location
  size                = "Standard_D2_v4"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.AVD-NIC1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }
  identity {
    type = "SystemAssigned"
  }
  tags = {
  type = "VM"
  RG ="AVD-RG"
  project = "AVD"
  }
}

#Entra ID Joining the AVD Machine
resource "azurerm_virtual_machine_extension" "aad_join" {
  name                 = "AADJoin"
  virtual_machine_id   = azurerm_windows_virtual_machine.AVD-VM1.id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADLoginForWindows"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true
}

# Security Group - allowing RDP Connection
resource "azurerm_network_security_group" "AVD-SG" {
  name                = "AVD-SG"
  location            = azurerm_resource_group.AVD-RG.location
  resource_group_name = azurerm_resource_group.AVD-RG.name

  security_rule {
    name                       = "rdpport"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
  type = "sg"
  RG ="AVD-RG"
  project = "AVD"
  }
}

# Associate security group with network interface
resource "azurerm_network_interface_security_group_association" "SG-Associate" {
  network_interface_id      = azurerm_network_interface.AVD-NIC1.id
  network_security_group_id = azurerm_network_security_group.AVD-SG.id
}

#Assign Public IP to the AVD VM
resource "azurerm_public_ip" "PublicIP1" {
  name                = "PublicIP"
  resource_group_name = azurerm_resource_group.AVD-RG.name
  location            = azurerm_resource_group.AVD-RG.location
  allocation_method   = "Dynamic"

  tags = {
  type = "Public IP"
  RG ="AVD-RG"
  project = "AVD"
  }
}

#Custom Extension to add the AVD to the Host Pool
resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  name                       = "AVD-Extension-1"
  virtual_machine_id         = azurerm_windows_virtual_machine.AVD-VM1.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName": "azurerm_virtual_desktop_host_pool.hostpool.name"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${local.registration_token}"
    }
  }
PROTECTED_SETTINGS
}

#Add Applications

#Google Chrome Published for the users
resource "azurerm_virtual_desktop_application" "chrome" {
  name                         = "googlechrome"
  application_group_id         = azurerm_virtual_desktop_application_group.RemoteAppGroup.id
  friendly_name                = "Google Chrome"
  description                  = "Chromium based web browser"
  path                         = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
  command_line_argument_policy = "DoNotAllow"
  command_line_arguments       = "--incognito"
  show_in_portal               = false
  icon_path                    = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
  icon_index                   = 0
}
#Comment Test