resource "azurerm_mssql_server" "sql" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  version                      = var.sql_version
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password

  tags = var.common_tags
}