variable "name" {
  description = "Name of the App Service"
  type        = string
}

variable "location" {
  description = "Location of the App Service"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "app_service_plan_id" {
  description = "ID of the App Service Plan"
  type        = string
}

variable "ip_restrictions" {
  description = "List of IP restrictions"
  type = list(object({
    name        = string
    action      = string
    priority    = number
    ip_address  = optional(string)
    service_tag = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to the App Service"
  type        = map(string)
  default     = {}
}
