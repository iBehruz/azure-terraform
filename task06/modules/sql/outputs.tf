output "sql_server_fqdn" {
  description = "SQL Server FQDN"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_server_id" {
  description = "SQL Server ID"
  value       = azurerm_mssql_server.main.id
}

output "sql_database_id" {
  description = "SQL Database ID"
  value       = azurerm_mssql_database.main.id
}

output "sql_connection_string" {
  description = "SQL Database connection string for ADO.NET"
  value = format(
    "Server=tcp:%s,1433;Initial Catalog=%s;Persist Security Info=False;User ID=%s;Password=%s;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
    azurerm_mssql_server.main.fully_qualified_domain_name,
    azurerm_mssql_database.main.name,
    var.sql_admin_username,
    random_password.sql_admin.result
  )
  sensitive = true
}
