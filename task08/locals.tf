locals {
  # Resource names using Terraform functions
  rg_name       = format("%s-rg", var.name_prefix)
  aci_name      = format("%s-ci", var.name_prefix)
  acr_name      = replace(format("%scr", var.name_prefix), "-", "")
  aks_name      = format("%s-aks", var.name_prefix)
  keyvault_name = format("%s-kv", var.name_prefix)
  redis_name    = format("%s-redis", var.name_prefix)
  
  # Additional configurations
  app_image_name = format("%s-app", var.name_prefix)
  image_tag      = "latest"
  
  # Redis configuration
  redis_hostname_secret = "redis-hostname"
  redis_key_secret      = "redis-primary-key"
}
