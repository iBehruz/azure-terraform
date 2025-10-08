locals {
  # Resource names using Terraform functions
  rg_name       = "westus"
  aci_name      = "cmtr-31zawnrd-mod8-ci"
  acr_name      = "cmtr31zawnrdmod8cr"
  aks_name      = "cmtr-31zawnrd-mod8-aks"
  keyvault_name = "cmtr-31zawnrd-mod8-kv"
  redis_name    = "cmtr-31zawnrd-mod8-redis"

  # Additional configurations
  app_image_name = "cmtr-31zawnrd-mod8-app"
  image_tag      = "latest"

  # Redis configuration
  redis_hostname_secret = "redis-hostname"
  redis_key_secret      = "redis-primary-key"
}
