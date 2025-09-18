# Data source for existing Key Vault
data "azurerm_key_vault" "existing" {
  name                = var.existing_kv_name
  resource_group_name = var.existing_kv_rg_name
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

# SQL Module
module "sql" {
  source = "./modules/sql"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sql_server_name     = local.sql_server_name
  sql_db_name         = local.sql_db_name
  sql_admin_username  = var.sql_admin_username
  sql_db_sku          = var.sql_db_sku
  allowed_ip_address  = var.allowed_ip_address
  firewall_rule_name  = local.sql_firewall_rule_name
  key_vault_id        = data.azurerm_key_vault.existing.id
  kv_secret_name_user = local.sql_admin_name_secret
  kv_secret_name_pass = local.sql_admin_password_secret
  tags                = var.tags

  depends_on = [azurerm_resource_group.main]
}

# Web App Module
module "webapp" {
  source = "./modules/webapp"

  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  asp_name              = local.asp_name
  app_name              = local.app_name
  asp_sku               = var.asp_sku
  webapp_dotnet_version = var.webapp_dotnet_version
  sql_connection_string = module.sql.sql_connection_string
  tags                  = var.tags

  depends_on = [module.sql]
}
