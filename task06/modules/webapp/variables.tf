variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "asp_name" {
  description = "App Service Plan name"
  type        = string
}

variable "app_name" {
  description = "Web App name"
  type        = string
}

variable "asp_sku" {
  description = "App Service Plan SKU"
  type        = string
}

variable "webapp_dotnet_version" {
  description = "Web App .NET version"
  type        = string
}

variable "sql_connection_string" {
  description = "SQL connection string"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
