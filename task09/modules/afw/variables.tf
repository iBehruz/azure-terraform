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

variable "aks_loadbalancer_ip" {
  description = "Public IP address of the AKS load balancer"
  type        = string
}

variable "firewall_subnet_prefix" {
  description = "Address prefix for Azure Firewall subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
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
  default = [
    {
      name             = "allow-aks-required-fqdns"
      source_addresses = ["*"]
      target_fqdns = [
        "*.hcp.eastus.azmk8s.io",
        "mcr.microsoft.com",
        "*.data.mcr.microsoft.com",
        "management.azure.com",
        "login.microsoftonline.com",
        "packages.microsoft.com",
        "acs-mirror.azureedge.net",
        "*.ubuntu.com",
        "api.snapcraft.io"
      ]
      protocols = [
        { port = "443", type = "Https" },
        { port = "80", type = "Http" }
      ]
    },
    {
      name             = "allow-docker-registry"
      source_addresses = ["*"]
      target_fqdns = [
        "*.docker.io",
        "docker.io",
        "registry-1.docker.io",
        "auth.docker.io",
        "production.cloudflare.docker.com"
      ]
      protocols = [
        { port = "443", type = "Https" },
        { port = "80", type = "Http" }
      ]
    }
  ]
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
  default = [
    {
      name                  = "allow-dns"
      source_addresses      = ["*"]
      destination_ports     = ["53"]
      destination_addresses = ["*"]
      destination_fqdns     = []
      protocols             = ["UDP"]
    },
    {
      name                  = "allow-ntp"
      source_addresses      = ["*"]
      destination_ports     = ["123"]
      destination_addresses = []
      destination_fqdns     = ["ntp.ubuntu.com"]
      protocols             = ["UDP"]
    }
  ]
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
  default = [
    {
      name              = "nginx-http"
      source_addresses  = ["*"]
      destination_ports = ["80"]
      translated_port   = 80
      protocols         = ["TCP"]
    },
    {
      name              = "nginx-https"
      source_addresses  = ["*"]
      destination_ports = ["443"]
      translated_port   = 443
      protocols         = ["TCP"]
    }
  ]
}
