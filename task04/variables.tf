variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
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

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_prefix" {
  description = "The address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "nic_name" {
  description = "The name of the network interface"
  type        = string
}

variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
}

variable "nsg_rule_http" {
  description = "The name of the NSG HTTP rule"
  type        = string
}

variable "nsg_rule_ssh" {
  description = "The name of the NSG SSH rule"
  type        = string
}

variable "public_ip_name" {
  description = "The name of the public IP"
  type        = string
}

variable "domain_name_label" {
  description = "The DNS domain name label for the public IP"
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "vm_os_version" {
  description = "The OS version for the virtual machine"
  type        = string
  default     = "24_04-lts"
}

variable "vm_sku" {
  description = "The SKU for the virtual machine"
  type        = string
  default     = "Standard_F2s_v2"
}

variable "vm_username" {
  description = "The admin username for the virtual machine"
  type        = string
  default     = "azureuser"
}

variable "vm_password" {
  description = "The admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}
