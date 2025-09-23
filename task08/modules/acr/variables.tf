variable "acr_name" {
  description = "Container Registry name"
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

variable "sku" {
  description = "ACR SKU"
  type        = string
}

variable "app_image_name" {
  description = "Docker image name"
  type        = string
}

variable "git_repo_url" {
  description = "Git repository URL"
  type        = string
}

variable "git_pat" {
  description = "Git personal access token"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
