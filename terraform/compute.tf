# Public IP for VM
resource "azurerm_public_ip" "web_pip" {
  name                = "web-pip"
  location            = "Central India"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Network Interface
resource "azurerm_network_interface" "web_nic" {
  name                = "web-nic"
  location            = "Central India"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_pip.id
  }
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "web_vm" {
  name                = "webvm"
  location            = "Central India"
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B2s"

  admin_username = "azureuser"
  admin_password = "Password1234!" # ⚠️ Must meet Azure complexity

  network_interface_ids = [
    azurerm_network_interface.web_nic.id
  ]

  os_disk {
    name                 = "webvm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  # 👇 Step 2 (already added)
  custom_data = base64encode(file("${path.module}/../scripts/app-setup.ps1"))

  # 👇 Step 3 (ADD HERE - inside VM block)
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
}