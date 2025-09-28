output "redis_id" {
  value = azurerm_redis_cache.main.id
}

output "redis_hostname" {
  value = azurerm_redis_cache.main.hostname
}

output "redis_ssl_port" {
  value = azurerm_redis_cache.main.ssl_port
}
