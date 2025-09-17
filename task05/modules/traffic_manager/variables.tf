variable "profile_name" {
  description = "Name of the Traffic Manager profile"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "routing_method" {
  description = "Routing method for the Traffic Manager profile"
  type        = string
  default     = "Performance"
}

variable "dns_ttl" {
  description = "DNS TTL for the Traffic Manager profile"
  type        = number
  default     = 60
}

variable "monitor_protocol" {
  description = "Protocol for monitoring endpoints"
  type        = string
  default     = "HTTPS"
}

variable "monitor_port" {
  description = "Port for monitoring endpoints"
  type        = number
  default     = 443
}

variable "monitor_path" {
  description = "Path for monitoring endpoints"
  type        = string
  default     = "/"
}

variable "endpoints" {
  description = "Map of endpoints for the Traffic Manager profile"
  type = map(object({
    name               = string
    target_resource_id = string
    location           = string
  }))
}

variable "tags" {
  description = "Tags to apply to the Traffic Manager profile"
  type        = map(string)
  default     = {}
}
