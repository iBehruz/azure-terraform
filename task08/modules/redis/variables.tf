variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "redis_hostname_secret" {
  type = string
}

variable "redis_key_secret" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "store_secrets_in_keyvault" {
  description = "Whether to store Redis secrets in Key Vault"
  type        = bool
  default     = true
}
