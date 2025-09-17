resource "azurerm_traffic_manager_profile" "this" {
  name                   = var.profile_name
  resource_group_name    = var.resource_group_name
  traffic_routing_method = var.routing_method
  
  dns_config {
    relative_name = var.profile_name
    ttl          = var.dns_ttl
  }
  
  monitor_config {
    protocol                     = var.monitor_protocol
    port                        = var.monitor_port
    path                        = var.monitor_path
    interval_in_seconds         = 30
    timeout_in_seconds          = 10
    tolerated_number_of_failures = 3
  }
  
  tags = var.tags
}

# Using for_each for Traffic Manager endpoints
resource "azurerm_traffic_manager_azure_endpoint" "this" {
  for_each = var.endpoints
  
  name               = each.value.name
  profile_id         = azurerm_traffic_manager_profile.this.id
  target_resource_id = each.value.target_resource_id
  
  # Priority based on key for predictable ordering
  priority = each.key == "app1" ? 1 : 2
  
  # Weight for load balancing
  weight = 100
}
