variable "resource_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the existing virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space of the existing VNET"
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "aks_loadbalancer_ip" {
  description = "Public IP address of the AKS load balancer"
  type        = string
}

variable "firewall_subnet_prefix" {
  description = "Address prefix for Azure Firewall subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "application_rules" {
  description = "Application rules for Azure Firewall"
  type = list(object({
    name             = string
    source_addresses = list(string)
    target_fqdns     = list(string)
    protocols = list(object({
      port = string
      type = string
    }))
  }))
}

variable "network_rules" {
  description = "Network rules for Azure Firewall"
  type = list(object({
    name                  = string
    source_addresses      = list(string)
    destination_ports     = list(string)
    destination_addresses = list(string)
    destination_fqdns     = list(string)
    protocols             = list(string)
  }))
}

variable "nat_rules" {
  description = "NAT rules for Azure Firewall"
  type = list(object({
    name              = string
    source_addresses  = list(string)
    destination_ports = list(string)
    translated_port   = number
    protocols         = list(string)
  }))
}
