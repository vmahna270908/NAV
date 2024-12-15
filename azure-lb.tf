# Create Network Security Group and rules for Load Balancer
resource "azurerm_network_security_group" "AZ-NAV-LB-NSG" {
  name                = "AZ-NAV-LB-NSG"
  location            = data.azurerm_resource_group.Dev-RG.location
  resource_group_name = data.azurerm_resource_group.Dev-RG.name

  security_rule {
    name                       = "Web"
    priority                   = 1008
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "192.168.0.8/29"
  }
}

# Associate the Network Security Group to the subnet for the Load Balancer
resource "azurerm_subnet_network_security_group_association" "AZ-NAV-LB-NSG-Attach" {
  subnet_id                 = azurerm_subnet.AZ-NAV-vNet-LB.id
  network_security_group_id = azurerm_network_security_group.AZ-NAV-LB-NSG.id
}

# Create Public IP for Load Balancer
resource "azurerm_public_ip" "LB_Public_IP" {
  name                = var.public_ip_name
  location            = data.azurerm_resource_group.Dev-RG.location
  resource_group_name = data.azurerm_resource_group.Dev-RG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create Network Interface for Web Servers for Load Balancer
resource "azurerm_network_interface" "AZ-NAV-App-NIC" {
  count               = 2
  name                = "${var.network_interface_name}${count.index}"
  location            = data.azurerm_resource_group.Dev-RG.location
  resource_group_name = data.azurerm_resource_group.Dev-RG.name

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = azurerm_subnet.AZ-NAV-vNet-App.id
    private_ip_address_allocation = "Dynamic"
    primary = true
  }
}

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "AZ-NAV-App-Servers" {
  count                 = 2
  name                  = "${var.virtual_machine_name}${count.index}"
  location              = data.azurerm_resource_group.Dev-RG.location
  resource_group_name   = data.azurerm_resource_group.Dev-RG.name
  network_interface_ids = [azurerm_network_interface.AZ-NAV-App-NIC[count.index].id]
  size                  = var.virtual_machine_size

  os_disk {
    name                 = "${var.disk_name}${count.index}"
    caching              = "ReadWrite"
    storage_account_type = var.redundancy_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

}

# Enable virtual machine extension and install Nginx
resource "azurerm_virtual_machine_extension" "AZ-NAV-App-Extension" {
  count                = 2
  name                 = "Nginx"
  virtual_machine_id   = azurerm_linux_virtual_machine.AZ-NAV-App-Servers[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
  "commandToExecute": "sudo apt-get update && sudo apt-get install nginx -y && echo \"Hello World from $(hostname)\" > /var/www/html/index.html && sudo systemctl restart nginx"
 }
SETTINGS

}

# Create Public Load Balancer
resource "azurerm_lb" "AZ-NAV-LB" {
  name                = var.load_balancer_name
  location            = data.azurerm_resource_group.Dev-RG.location
  resource_group_name = data.azurerm_resource_group.Dev-RG.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = var.public_ip_name
    public_ip_address_id = azurerm_public_ip.LB_Public_IP.id
  }
}
resource "azurerm_lb_backend_address_pool" "AZ-NAV-LB_Pool" {
  loadbalancer_id      = azurerm_lb.AZ-NAV-LB.id
  name                 = "NAV-LB-Pool"
}
resource "azurerm_lb_probe" "AZ-NAV-LB_Probe" {
  loadbalancer_id     = azurerm_lb.AZ-NAV-LB.id
  name                = "NAV-LB-Probe"
  port                = 80
}
resource "azurerm_lb_rule" "AZ-NAV-LB_Rule" {
  loadbalancer_id                = azurerm_lb.AZ-NAV-LB.id
  name                           = "NAV-LB-Rule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  disable_outbound_snat          = true
  frontend_ip_configuration_name = var.public_ip_name
  probe_id                       = azurerm_lb_probe.AZ-NAV-LB_Probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.AZ-NAV-LB_Pool.id]
}

