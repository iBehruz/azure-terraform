resource "azurerm_container_registry" "acr" {
  name                = "cmtr31zawnrdmod8cr"
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_registry_task" "acr_task" {
  name                  = "cmtr31zawnrdmod8task"
  container_registry_id = azurerm_container_registry.acr.id
  platform {
    os           = "Linux"
    architecture = "amd64"
  }

  docker_step {
    context_access_token = "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"
    dockerfile_path      = "application/Dockerfile"
    context_path         = "application"
    image_names          = ["cmtr-31zawnrd-mod8-app:latest"]
  }

  timeout_in_seconds = 1800
  enabled            = true
}
