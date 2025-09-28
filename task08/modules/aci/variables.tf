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

variable "acr_username" {
  description = "ACR username"
  type        = string
}

variable "acr_password" {
  description = "ACR password"
  type        = string
  sensitive   = true
}

variable "app_image_name" {
  description = "Docker image name"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}

variable "redis_hostname_secret" {
  description = "Redis hostname secret name"
  type        = string
}

variable "redis_key_secret" {
  description = "Redis key secret name"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}