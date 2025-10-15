output "host"                   { value = azurerm_kubernetes_cluster.main.kube_config[0].host }
output "client_certificate"     { value = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate }
output "client_key"             { value = azurerm_kubernetes_cluster.main.kube_config[0].client_key }
output "cluster_ca_certificate" { value = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate }


output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].object_id
}
output "aks_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.main.node_resource_group
}
