output "v_redis_hostname" {
  value = azurerm_redis_cache.main.hostname
}

output "v_redis_key" {
  value = azurerm_redis_cache.main.primary_access_key
}