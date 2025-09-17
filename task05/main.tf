module "resource_groups" {
  source   = "./modules/resource_group"
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
  tags     = var.tags
}

module "app_service_plans" {
  source   = "./modules/app_service_plan"
  for_each = var.app_service_plans

  name                = each.value.name
  location            = module.resource_groups[each.value.resource_group_key].location
  resource_group_name = module.resource_groups[each.value.resource_group_key].name
  sku_name            = each.value.sku_name
  worker_count        = each.value.worker_count
  tags                = var.tags

  depends_on = [module.resource_groups]
}

module "app_services" {
  source   = "./modules/app_service"
  for_each = var.app_services

  name                = each.value.name
  location            = module.resource_groups[each.value.resource_group_key].location
  resource_group_name = module.resource_groups[each.value.resource_group_key].name
  app_service_plan_id = module.app_service_plans[each.value.app_service_plan_key].id
  ip_restrictions     = each.value.ip_restrictions
  tags                = var.tags

  depends_on = [module.app_service_plans]
}

module "traffic_manager" {
  source = "./modules/traffic_manager"

  profile_name        = var.traffic_manager.profile_name
  resource_group_name = module.resource_groups[var.traffic_manager.resource_group_key].name
  routing_method      = var.traffic_manager.routing_method
  dns_ttl             = var.traffic_manager.dns_ttl
  monitor_protocol    = var.traffic_manager.monitor_protocol
  monitor_port        = var.traffic_manager.monitor_port
  monitor_path        = var.traffic_manager.monitor_path

  endpoints = {
    for key, app in module.app_services : key => {
      name               = "${app.name}-endpoint"
      target_resource_id = app.id
      location           = app.location
    }
  }

  tags = var.tags

  depends_on = [module.app_services]
}
