resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_name
  
  default_node_pool {
    name                = "system"
    node_count          = 1
    vm_size            = "Standard_D2ads_v5"
    os_disk_type       = "Ephemeral"
    os_disk_size_gb    = 48
    enable_auto_scaling = false
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
  
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  
  tags = var.tags
}

# Role assignment for ACR pull
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                           = var.acr_id
  skip_service_principal_aad_check = true
}

# Key Vault access policy for AKS
resource "azurerm_key_vault_access_policy" "aks" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_kubernetes_cluster.main.identity[0].tenant_id
  object_id    = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].object_id
  
  secret_permissions = ["Get", "List"]
}
