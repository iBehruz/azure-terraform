output "traffic_manager_fqdn" {
  description = "FQDN of the Traffic Manager profile"
  value       = module.traffic_manager.fqdn
}

output "resource_groups" {
  description = "Details of created resource groups"
  value = {
    for key, rg in module.resource_groups : key => {
      id       = rg.id
      name     = rg.name
      location = rg.location
    }
  }
}

output "app_service_urls" {
  description = "URLs of the App Services"
  value = {
    for key, app in module.app_services : key => app.default_hostname
  }
}

output "app_service_plans" {
  description = "Details of created App Service Plans"
  value = {
    for key, asp in module.app_service_plans : key => {
      id   = asp.id
      name = asp.name
    }
  }
}
