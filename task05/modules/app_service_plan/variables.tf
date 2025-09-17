variable "name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "location" {
  description = "Location of the App Service Plan"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the App Service Plan"
  type        = string
}

variable "worker_count" {
  description = "Number of workers for the App Service Plan"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to apply to the App Service Plan"
  type        = map(string)
  default     = {}
}
