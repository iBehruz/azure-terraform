resource "azurerm_redis_cache" "main" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 2
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  
  redis_configuration {}
  
  tags = var.tags
}

resource "azurerm_key_vault_secret" "redis_hostname" {
  name         = var.redis_hostname_secret
  value        = azurerm_redis_cache.main.hostname
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "redis_primary_key" {
  name         = var.redis_key_secret
  value        = azurerm_redis_cache.main.primary_access_key
  key_vault_id = var.key_vault_id
}
