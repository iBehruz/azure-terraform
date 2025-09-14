# Resource Group ID
output "rg_id" {
  description = "The ID of the Resource Group"
  value       = azurerm_resource_group.main.id
}

# Storage Account Blob Service Primary Endpoint
output "sa_blob_endpoint" {
  description = "The primary blob endpoint for the Storage Account"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

# Virtual Network ID
output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}
