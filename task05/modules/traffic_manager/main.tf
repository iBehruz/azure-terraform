resource "azurerm_traffic_manager_profile" "this" {
  name                   = var.profile_name
  resource_group_name    = var.resource_group_name
  traffic_routing_method = var.routing_method

  dns_config {
    relative_name = var.profile_name
    ttl           = var.dns_ttl
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = var.monitor_path
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
    expected_status_code_ranges  = ["200-202", "301-302"]
  }

  tags = var.tags
}

resource "azurerm_traffic_manager_azure_endpoint" "this" {
  for_each = var.endpoints

  name               = each.value.name
  profile_id         = azurerm_traffic_manager_profile.this.id
  target_resource_id = each.value.target_resource_id

  priority = each.key == "app1" ? 1 : 2

  weight = 100
}