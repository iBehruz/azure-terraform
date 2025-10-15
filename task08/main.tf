data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "keyvault" {
  source              = "./modules/keyvault"
  name                = local.keyvault_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}

module "redis" {
  source                = "./modules/redis"
  name                  = local.redis_name
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  redis_hostname_secret = local.redis_hostname_secret
  redis_key_secret      = local.redis_key_secret
  key_vault_id          = module.keyvault.key_vault_id
  depends_on            = [module.keyvault]
}

module "acr" {
  source      = "./modules/acr"
  rg_location = azurerm_resource_group.main.location
  rg_name     = azurerm_resource_group.main.name
  acr_name    = local.acr_name
}

module "aci" {
  source = "./modules/aci"

  aci_name              = local.aci_name
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  acr_login_server      = module.acr.login_server
  acr_username          = module.acr.admin_username
  acr_password          = module.acr.admin_password
  key_vault_id          = module.keyvault.key_vault_id
  tags                  = var.tags
  redis_hostname_secret = local.redis_hostname_secret
  redis_key_secret      = local.redis_key_secret

  depends_on = [
    module.acr,
    module.redis,
    module.keyvault
  ]
}

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

provider "kubectl" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}


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

data "kubernetes_service" "app" {
  metadata {
    name = "redis-flask-app-service"
  }

  depends_on = [kubectl_manifest.service]
}
