resource "azurerm_mssql_server" "sql" {
  name                         = "3tier-sqlserver"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = "Central India"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Password1234!"
}