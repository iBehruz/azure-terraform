output "id" {
  description = "The ID of the Traffic Manager profile"
  value       = azurerm_traffic_manager_profile.this.id
}

output "name" {
  description = "The name of the Traffic Manager profile"
  value       = azurerm_traffic_manager_profile.this.name
}

output "fqdn" {
  description = "The FQDN of the Traffic Manager profile"
  value       = azurerm_traffic_manager_profile.this.fqdn
}

output "endpoints" {
  description = "The endpoints of the Traffic Manager profile"
  value       = {
    for key, endpoint in azurerm_traffic_manager_azure_endpoint.this : key => {
      id   = endpoint.id
      name = endpoint.name
    }
  }
}
