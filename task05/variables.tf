variable "resource_groups" {
  description = "Map of resource groups to create"
  type = map(object({
    name     = string
    location = string
  }))
}

variable "app_service_plans" {
  description = "Map of app service plans to create"
  type = map(object({
    name               = string
    resource_group_key = string
    sku_name           = string
    worker_count       = number
  }))
}

variable "app_services" {
  description = "Map of app services to create"
  type = map(object({
    name                 = string
    resource_group_key   = string
    app_service_plan_key = string
    ip_restrictions = list(object({
      name        = string
      action      = string
      priority    = number
      ip_address  = optional(string)
      service_tag = optional(string)
    }))
  }))
}

variable "traffic_manager" {
  description = "Traffic Manager configuration"
  type = object({
    profile_name       = string
    resource_group_key = string
    routing_method     = string
    dns_ttl            = number
    monitor_protocol   = string
    monitor_port       = number
    monitor_path       = string
  })
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "verification_agent_ip" {
  description = "IP address of the verification agent"
  type        = string
  default     = "18.153.146.156"
}
