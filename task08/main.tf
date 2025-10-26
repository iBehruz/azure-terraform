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
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  tags                = var.tags

  depends_on = [
    module.acr,
    module.keyvault
  ]
}


data "azurerm_kubernetes_cluster" "main" {
  name                = module.aks.azurerm_kubernetes_cluster_name
  resource_group_name = azurerm_resource_group.main.name
}


provider "kubectl" {
  alias                  = "alekc"
  host                   = data.azurerm_kubernetes_cluster.main.kube_config[0].host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "az"
    args        = ["aks", "get-credentials", "--resource-group", var.resource_group_name, "--name", data.azurerm_kubernetes_cluster.main.name, "--admin", "--overwrite-existing"]
  }
}

resource "kubectl_manifest" "secret_provider" {
  provider = kubectl.alekc
  yaml_body = templatefile("${path.module}/k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = module.aks.kubelet_identity_object_id
    kv_name                    = local.keyvault_name
    redis_url_secret_name      = local.redis_hostname_secret
    redis_password_secret_name = local.redis_key_secret
    tenant_id                  = data.azurerm_client_config.current.tenant_id
  })
}

resource "kubectl_manifest" "deployment" {
  provider = kubectl.alekc
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
  provider  = kubectl.alekc
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
