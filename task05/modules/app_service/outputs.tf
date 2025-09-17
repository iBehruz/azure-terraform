output "id" {
  description = "The ID of the App Service"
  value       = azurerm_windows_web_app.this.id
}

output "name" {
  description = "The name of the App Service"
  value       = azurerm_windows_web_app.this.name
}

output "default_hostname" {
  description = "The default hostname of the App Service"
  value       = azurerm_windows_web_app.this.default_hostname
}

output "location" {
  description = "The location of the App Service"
  value       = azurerm_windows_web_app.this.location
}

output "outbound_ip_addresses" {
  description = "The outbound IP addresses of the App Service"
  value       = azurerm_windows_web_app.this.outbound_ip_addresses
}
