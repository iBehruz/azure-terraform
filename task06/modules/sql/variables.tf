variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sql_server_name" {
  description = "SQL Server name"
  type        = string
}

variable "sql_db_name" {
  description = "SQL Database name"
  type        = string
}

variable "sql_admin_username" {
  description = "SQL administrator username"
  type        = string
}

variable "sql_db_sku" {
  description = "SQL Database SKU"
  type        = string
}

variable "allowed_ip_address" {
  description = "IP address allowed to connect"
  type        = string
}

variable "firewall_rule_name" {
  description = "Firewall rule name"
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}

variable "kv_secret_name_user" {
  description = "Key Vault secret name for SQL username"
  type        = string
}

variable "kv_secret_name_pass" {
  description = "Key Vault secret name for SQL password"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
