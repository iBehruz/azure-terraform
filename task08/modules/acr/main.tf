resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = true
  
  tags = var.tags
}

resource "azurerm_container_registry_task" "build_task" {
  name                  = "build-app"
  container_registry_id = azurerm_container_registry.main.id
  platform {
    os           = "Linux"
    architecture = "amd64"
  }
  
  docker_step {
    dockerfile_path            = "application/Dockerfile"
    context_path              = "."
    context_access_token      = var.git_pat
    image_names               = ["${var.app_image_name}:latest"]
  }
  
  source_trigger {
    name           = "commit"
    events         = ["commit"]
    source_type    = "Github"
    repository_url = var.git_repo_url
    branch         = "main"
    
    authentication {
      token      = var.git_pat
      token_type = "PAT"
    }
  }
}

resource "azurerm_container_registry_task_schedule_run_now" "initial_build" {
  container_registry_task_id = azurerm_container_registry_task.build_task.id
}
