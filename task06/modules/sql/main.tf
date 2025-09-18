# Generate random password for SQL admin
resource "random_password" "sql_admin" {
  length  = 20
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# Store SQL admin username in Key Vault
resource "azurerm_key_vault_secret" "sql_admin_username" {
  name         = var.kv_secret_name_user
  value        = var.sql_admin_username
  key_vault_id = var.key_vault_id
}

# Store SQL admin password in Key Vault
resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = var.kv_secret_name_pass
  value        = random_password.sql_admin.result
  key_vault_id = var.key_vault_id
}

# SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = random_password.sql_admin.result
  minimum_tls_version          = "1.2"

  tags = var.tags
}

# SQL Database
resource "azurerm_mssql_database" "main" {
  name        = var.sql_db_name
  server_id   = azurerm_mssql_server.main.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = 250
  sku_name    = var.sql_db_sku

  tags = var.tags
}

# Firewall rule for Azure services
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Firewall rule for specific IP
resource "azurerm_mssql_firewall_rule" "allowed_ip" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = var.allowed_ip_address
  end_ip_address   = var.allowed_ip_address
}
