resource "azurerm_network_security_group" "AZ-NAV-SQL-NSG" {
  name                = "AZ-NAV-SQL-NSG"
  location            = data.azurerm_resource_group.Dev-RG.location
  resource_group_name = data.azurerm_resource_group.Dev-RG.name
}

resource "azurerm_network_security_rule" "allow_management_inbound" {
  name                        = "allow_management_inbound"
  priority                    = 106
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["9000", "9003", "1438", "1440", "1452"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.Dev-RG.name
  network_security_group_name = azurerm_network_security_group.AZ-NAV-SQL-NSG.name
}

resource "azurerm_network_security_rule" "allow_misubnet_inbound" {
  name                        = "allow_misubnet_inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "192.168.0.24/29"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.Dev-RG.name
  network_security_group_name = azurerm_network_security_group.AZ-NAV-SQL-NSG.name
}

resource "azurerm_network_security_rule" "allow_health_probe_inbound" {
  name                        = "allow_health_probe_inbound"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.Dev-RG.name
  network_security_group_name = azurerm_network_security_group.AZ-NAV-SQL-NSG.name
}

resource "azurerm_network_security_rule" "allow_tds_inbound" {
  name                        = "allow_tds_inbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.Dev-RG.name
  network_security_group_name = azurerm_network_security_group.AZ-NAV-SQL-NSG.name
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "deny_all_inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.Dev-RG.name
  network_security_group_name = azurerm_network_security_group.AZ-NAV-SQL-NSG.name
}

resource "azurerm_network_security_rule" "allow_management_outbound" {
  name                        = "allow_management_outbound"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443", "12000"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.Dev-RG.name
  network_security_group_name = azurerm_network_security_group.AZ-NAV-SQL-NSG.name
}

resource "azurerm_network_security_rule" "allow_misubnet_outbound" {
  name                        = "allow_misubnet_outbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "192.168.0.24/29"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.Dev-RG.name
  network_security_group_name = azurerm_network_security_group.AZ-NAV-SQL-NSG.name
}

resource "azurerm_subnet_network_security_group_association" "AZ-NAV-SQL-NSG-Attach" {
  subnet_id                 = azurerm_subnet.AZ-NAV-vNet-SQL.id
  network_security_group_id = azurerm_network_security_group.AZ-NAV-SQL-NSG.id
}

resource "azurerm_route_table" "AZ-NAV-SQL-routetable" {
  name                          = "AZ-NAV-SQL-routetable"
  location                      = data.azurerm_resource_group.Dev-RG.location
  resource_group_name           = data.azurerm_resource_group.Dev-RG.name
  depends_on = [
    azurerm_subnet.AZ-NAV-vNet-SQL,
  ]
}

resource "azurerm_subnet_route_table_association" "AZ-NAV-SQL-routetable-Attach" {
  subnet_id      = azurerm_subnet.AZ-NAV-vNet-SQL.id
  route_table_id = azurerm_route_table.AZ-NAV-SQL-routetable.id
}

resource "azurerm_mssql_managed_instance" "AZ-NAV-SQL" {
  name                = "managedsqlinstance"
  location                      = data.azurerm_resource_group.Dev-RG.location
  resource_group_name           = data.azurerm_resource_group.Dev-RG.name

  license_type       = "BasePrice"
  sku_name           = "GP_Gen5"
  storage_size_in_gb = 32
  subnet_id          = azurerm_subnet.AZ-NAV-vNet-SQL.id
  vcores             = 4

  administrator_login          = "mradministrator"
  administrator_login_password = "thisIsDog11"

  depends_on = [
    azurerm_subnet_network_security_group_association.AZ-NAV-SQL-NSG-Attach,
    azurerm_subnet_route_table_association.AZ-NAV-SQL-routetable-Attach,
  ]
}