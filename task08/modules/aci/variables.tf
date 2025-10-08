variable "aci_name" {
  description = "Container Instance name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "acr_login_server" {
  description = "ACR login server"
  type        = string
}

variable "acr_password" {
  type = string
}

variable "acr_username" {
  type = string
}

variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}

variable "redis_hostname_secret" {
  description = "Redis hostname secret value"
  type        = string
  default     = "test"
}

variable "redis_key_secret" {
  description = "Redis key secret value"
  type        = string
  default     = "value"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
