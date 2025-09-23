variable "keyvault_name" {
  description = "Key Vault name"
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

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "object_id" {
  description = "Object ID for access policy"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
