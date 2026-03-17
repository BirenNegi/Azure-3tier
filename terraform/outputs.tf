# ============================================================================
# OUTPUTS - Display important resource information after deployment
# ============================================================================

# RESOURCE GROUP OUTPUTS
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.rg.id
}

output "location" {
  description = "Azure region where resources are deployed"
  value       = azurerm_resource_group.rg.location
}

# ============================================================================
# NETWORK OUTPUTS
# ============================================================================
output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "web_subnet_id" {
  description = "ID of the web subnet"
  value       = azurerm_subnet.web.id
}

output "app_subnet_id" {
  description = "ID of the app subnet"
  value       = azurerm_subnet.app.id
}

output "db_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.db.id
}

output "web_nsg_id" {
  description = "ID of the web network security group"
  value       = azurerm_network_security_group.web_nsg.id
}

# ============================================================================
# COMPUTE/VM OUTPUTS
# ============================================================================
output "web_vm_id" {
  description = "ID of the web virtual machine"
  value       = azurerm_windows_virtual_machine.web_vm.id
}

output "web_vm_name" {
  description = "Name of the web virtual machine"
  value       = azurerm_windows_virtual_machine.web_vm.name
}

output "web_vm_private_ip" {
  description = "Private IP address of the web VM"
  value       = azurerm_network_interface.web_nic.private_ip_addresses[0]
}

output "web_vm_public_ip" {
  description = "Public IP address of the web VM"
  value       = azurerm_public_ip.web_pip.ip_address
  sensitive   = false
}

output "web_vm_fqdn" {
  description = "Fully qualified domain name of the public IP"
  value       = azurerm_public_ip.web_pip.fqdn
}

output "web_vm_size" {
  description = "Size of the web virtual machine"
  value       = azurerm_windows_virtual_machine.web_vm.size
}

output "web_nic_id" {
  description = "ID of the web network interface"
  value       = azurerm_network_interface.web_nic.id
}

output "web_pip_id" {
  description = "ID of the web public IP"
  value       = azurerm_public_ip.web_pip.id
}

output "vm_connection_string" {
  description = "Connection string for RDP access to the VM"
  value       = "mstsc.exe /v:${azurerm_public_ip.web_pip.ip_address}:3389 /admin"
  sensitive   = false
}

# ============================================================================
# DATABASE OUTPUTS
# ============================================================================
output "sql_server_id" {
  description = "ID of the SQL Server"
  value       = azurerm_mssql_server.sql.id
}

output "sql_server_name" {
  description = "Name of the SQL Server"
  value       = azurerm_mssql_server.sql.name
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.sql.fully_qualified_domain_name
}

output "sql_connection_string" {
  description = "SQL Server connection string (requires database)"
  value       = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Initial Catalog=YourDatabase;Persist Security Info=False;User ID=sqladmin;Password=***;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}

# ============================================================================
# CONFIGURATION SUMMARY
# ============================================================================
output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    resource_group = azurerm_resource_group.rg.name
    location       = azurerm_resource_group.rg.location
    vnet           = azurerm_virtual_network.vnet.name
    web_vm         = azurerm_windows_virtual_machine.web_vm.name
    web_vm_ip      = azurerm_public_ip.web_pip.ip_address
    sql_server     = azurerm_mssql_server.sql.name
    web_app_port   = var.app_port
    rdp_port       = var.rdp_port
  }
  sensitive = false
}
