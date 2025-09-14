variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_frontend_name" {
  description = "The name of the frontend subnet"
  type        = string
  default     = "frontend"
}

variable "subnet_frontend_prefix" {
  description = "The address prefix for the frontend subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_backend_name" {
  description = "The name of the backend subnet"
  type        = string
  default     = "backend"
}

variable "subnet_backend_prefix" {
  description = "The address prefix for the backend subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}
