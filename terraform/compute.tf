# Public IP for VM
resource "azurerm_public_ip" "web_pip" {
  name                = var.web_pip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = var.public_ip_allocation

  tags = var.common_tags
}

# Network Interface
resource "azurerm_network_interface" "web_nic" {
  name                = var.web_nic_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = var.private_ip_allocation
    public_ip_address_id          = azurerm_public_ip.web_pip.id
  }

  tags = var.common_tags
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "web_vm" {
  name                = var.web_vm_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.web_nic.id
  ]

  os_disk {
    name                 = var.os_disk_name
    caching              = var.os_disk_caching
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  # Custom data for running setup script
  custom_data = base64encode(file("${path.module}/../scripts/app-setup.ps1"))

  # Additional unattend content for running custom script
  additional_unattend_content {
    setting = "FirstLogonCommands"
    content = <<EOF
<FirstLogonCommands>
  <SynchronousCommand>
    <CommandLine>powershell -ExecutionPolicy Unrestricted -File C:\AzureData\CustomData.bin</CommandLine>
    <Description>Run custom script</Description>
    <Order>1</Order>
  </SynchronousCommand>
</FirstLogonCommands>
EOF
  }

  tags = var.common_tags
}