resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = true
  tags                = var.tags
}

resource "null_resource" "import_image" {
  provisioner "local-exec" {
    command = "az acr import --name ${azurerm_container_registry.main.name} --source mcr.microsoft.com/azuredocs/aks-helloworld:v1 --image ${var.app_image_name}:latest"
  }
  depends_on = [azurerm_container_registry.main]
}

# Create task without source trigger to avoid webhook errors
resource "azurerm_container_registry_task" "build_task" {
  name                  = "build-app"
  container_registry_id = azurerm_container_registry.main.id

  platform {
    os           = "Linux"
    architecture = "amd64"
  }

  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = "https://github.com/Azure-Samples/acr-build-helloworld-node.git"
    context_access_token = var.git_pat
    image_names          = ["${var.app_image_name}:latest"]
  }

  # Timer trigger instead of source trigger (runs once daily)
  timer_trigger {
    name     = "daily"
    schedule = "0 0 * * *"
  }
}

# Trigger initial build
resource "azurerm_container_registry_task_schedule_run_now" "initial_build" {
  container_registry_task_id = azurerm_container_registry_task.build_task.id
}