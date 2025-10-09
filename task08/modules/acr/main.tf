resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
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
    context_path         = "https://iBehruz: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@github.com/iBehruz/azure-terraform.git"
    context_access_token = "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"
    dockerfile_path      = "task08/application/Dockerfile"
    image_names          = ["cmtr-31zawnrd-mod8-app:latest"]
  }

  timeout_in_seconds = 1800
  enabled            = true
}

resource "azurerm_container_registry_task_schedule_run_now" "acr_task_run" {
  container_registry_task_id = azurerm_container_registry_task.acr_task.id
}
