resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space

  tags = var.common_tags
}

resource "azurerm_subnet" "web" {
  name                 = var.web_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.web_subnet_prefix
}

resource "azurerm_subnet" "app" {
  name                 = var.app_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.app_subnet_prefix
}

resource "azurerm_subnet" "db" {
  name                 = var.db_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.db_subnet_prefix
}

 resource "azurerm_network_security_group" "web_nsg" {
  name                = var.web_nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowApp"
    priority                   = var.app_priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = tostring(var.app_port)
    source_address_prefix      = var.allowed_source_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-rdp"
    priority                   = var.rdp_priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = tostring(var.rdp_port)
    source_address_prefix      = var.allowed_source_ip
    destination_address_prefix = "*"
  }

  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "web_nsg_assoc" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}
