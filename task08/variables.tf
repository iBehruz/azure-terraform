variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "cmtr-31zawnrd-mod8"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West US"
}

variable "acr_sku" {
  description = "ACR SKU"
  type        = string
  default     = "Basic"
}

variable "git_pat" {
  description = "Git personal access token"
  type        = string
  sensitive   = true
}

variable "git_repo_url" {
  description = "Git repository URL"
  type        = string
  default     = "https://github.com/username/repo.git"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Creator = "behroz_ilhomov@epam.com"
  }
}
