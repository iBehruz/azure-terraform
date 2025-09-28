# Get Redis secrets from Key Vault
data "azurerm_key_vault_secret" "redis_hostname" {
  name         = var.redis_hostname_secret
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "redis_key" {
  name         = var.redis_key_secret
  key_vault_id = var.key_vault_id
}

resource "azurerm_container_group" "main" {
  name                = var.aci_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  dns_name_label      = var.aci_name
  sku                 = "Standard"

  container {
    name   = "app"
    image  = "${var.acr_login_server}/${var.app_image_name}:${var.image_tag}"
    cpu    = "1.0"
    memory = "1.5"

    ports {
      port     = 8080
      protocol = "TCP"
    }

    environment_variables = {
      CREATOR        = "ACI"
      REDIS_PORT     = "6380"
      REDIS_SSL_MODE = "true"
    }

    secure_environment_variables = {
      REDIS_URL = data.azurerm_key_vault_secret.redis_hostname.value
      REDIS_PWD = data.azurerm_key_vault_secret.redis_key.value
    }
  }

  image_registry_credential {
    server   = var.acr_login_server
    username = var.acr_username
    password = var.acr_password
  }

  tags = var.tags
}
