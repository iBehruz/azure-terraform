output "app_hostname" {
  description = "Web App hostname"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "app_id" {
  description = "Web App ID"
  value       = azurerm_linux_web_app.main.id
}

output "asp_id" {
  description = "App Service Plan ID"
  value       = azurerm_service_plan.main.id
}
