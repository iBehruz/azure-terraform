# Data source for current subscription
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

# Key Vault Module
module "keyvault" {
  source = "./modules/keyvault"

  keyvault_name       = local.keyvault_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  tags                = var.tags
}

# Redis Module
module "redis" {
  source = "./modules/redis"

  redis_name            = local.redis_name
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  key_vault_id          = module.keyvault.key_vault_id
  redis_hostname_secret = local.redis_hostname_secret
  redis_key_secret      = local.redis_key_secret
  tags                  = var.tags

  depends_on = [module.keyvault]
}

# ACR Module
module "acr" {
  source = "./modules/acr"

  acr_name            = local.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.acr_sku
  app_image_name      = local.app_image_name
  git_repo_url        = var.git_repo_url
  git_pat             = var.git_pat
  tags                = var.tags
}

# ACI Module
module "aci" {
  source = "./modules/aci"

  aci_name              = local.aci_name
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  acr_login_server      = module.acr.login_server
  acr_username          = module.acr.admin_username
  acr_password          = module.acr.admin_password
  app_image_name        = local.app_image_name
  image_tag             = local.image_tag
  key_vault_id          = module.keyvault.key_vault_id
  redis_hostname_secret = local.redis_hostname_secret
  redis_key_secret      = local.redis_key_secret
  tags                  = var.tags

  depends_on = [
    module.acr,
    module.redis,
    module.keyvault
  ]
}

# AKS Module
module "aks" {
  source = "./modules/aks"

  aks_name            = local.aks_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  acr_id              = module.acr.acr_id
  key_vault_id        = module.keyvault.key_vault_id
  tags                = var.tags

  depends_on = [
    module.acr,
    module.keyvault
  ]
}

# Deploy K8s manifests
resource "kubectl_manifest" "secret_provider" {
  yaml_body = templatefile("${path.module}/k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = module.aks.kubelet_identity_object_id
    kv_name                    = local.keyvault_name
    redis_url_secret_name      = local.redis_hostname_secret
    redis_password_secret_name = local.redis_key_secret
    tenant_id                  = data.azurerm_client_config.current.tenant_id
  })

  depends_on = [module.aks]
}

resource "kubectl_manifest" "deployment" {
  yaml_body = templatefile("${path.module}/k8s-manifests/deployment.yaml.tftpl", {
    acr_login_server = module.acr.login_server
    app_image_name   = local.app_image_name
    image_tag        = local.image_tag
  })

  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }

  depends_on = [
    kubectl_manifest.secret_provider,
    module.acr
  ]
}

resource "kubectl_manifest" "service" {
  yaml_body = file("${path.module}/k8s-manifests/service.yaml")

  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}"
      value_type = "regex"
    }
  }

  depends_on = [kubectl_manifest.deployment]
}

# Data source to get LoadBalancer IP
data "kubernetes_service" "app" {
  metadata {
    name = "redis-flask-app-service"
  }

  depends_on = [kubectl_manifest.service]
}
