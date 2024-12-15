resource "azurerm_network_interface" "AZ-NAV-JMP1-NIC" {
  name                = var.JumpServer1_NIC
  location            = data.azurerm_resource_group.Dev-RG.location
  resource_group_name = data.azurerm_resource_group.Dev-RG.name

  ip_configuration {
    name                          = "JumpServer1"
    subnet_id                     = azurerm_subnet.AZ-NAV-vNet-LB.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "AZ-NAV-JMP1" {
  name                = var.JumpServer1_Name
  resource_group_name = data.azurerm_resource_group.Dev-RG.name
  location            = data.azurerm_resource_group.Dev-RG.location
  size                = "Standard_F2"
  admin_username      = "Skywalker"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.AZ-NAV-JMP1-NIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  tags = {
    environment = "Production"
    project = "NAV"
    type = "Jump Server"
  }
}



