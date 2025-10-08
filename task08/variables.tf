variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "West US"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Creator = "behroz_ilhomov@epam.com"
  }
}