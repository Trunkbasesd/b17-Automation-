resource "azurerm_mssql_database" "sql_db" {
  name      = var.sql_database
  server_id = azurerm_mssql_server.sql_server.id
}
