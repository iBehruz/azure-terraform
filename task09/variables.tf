variable "resource_prefix" {
  description = "Prefix for resource naming"
  type        = string
  default     = "cmtr-31zawnrd-mod9"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
  default     = "cmtr-31zawnrd-mod9-rg"
}

variable "vnet_name" {
  description = "Name of the existing virtual network"
  type        = string
  default     = "cmtr-31zawnrd-mod9-vnet"
}

variable "vnet_address_space" {
  description = "Address space of the existing VNET"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
  default     = "aks-snet"
}

variable "aks_loadbalancer_ip" {
  description = "Public IP address of the AKS load balancer"
  type        = string
}

variable "firewall_subnet_prefix" {
  description = "Address prefix for Azure Firewall subnet"
  type        = string
  default     = "10.0.1.0/24"
}
