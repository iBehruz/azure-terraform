variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "cmaz-31zawnrd-mod6"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "West US"
}

variable "existing_kv_rg_name" {
  description = "Existing Key Vault Resource Group name"
  type        = string
  default     = "cmaz-31zawnrd-mod6-kv-rg"
}

variable "existing_kv_name" {
  description = "Existing Key Vault name"
  type        = string
  default     = "cmaz-31zawnrd-mod6-kv"
}

variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
  default     = "sqladmin"
}

variable "sql_db_sku" {
  description = "SQL Database SKU"
  type        = string
  default     = "S2"
}

variable "asp_sku" {
  description = "App Service Plan SKU"
  type        = string
  default     = "P0v3"
}

variable "webapp_dotnet_version" {
  description = "Web App .NET version"
  type        = string
  default     = "8.0"
}

variable "allowed_ip_address" {
  description = "IP address allowed to connect to SQL Server"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Creator = "behroz_ilhomov@epam.com"
  }
}
