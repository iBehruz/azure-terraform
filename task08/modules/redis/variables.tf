variable "redis_name" {
  description = "Redis cache name"
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

variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}

variable "redis_hostname_secret" {
  description = "Secret name for Redis hostname"
  type        = string
}

variable "redis_key_secret" {
  description = "Secret name for Redis primary key"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
