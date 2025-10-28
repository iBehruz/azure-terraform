module "afw" {
  source = "./modules/afw"

  resource_prefix        = var.resource_prefix
  location               = var.location
  resource_group_name    = var.resource_group_name
  vnet_name              = var.vnet_name
  vnet_address_space     = var.vnet_address_space
  aks_subnet_name        = var.aks_subnet_name
  aks_loadbalancer_ip    = var.aks_loadbalancer_ip
  firewall_subnet_prefix = var.firewall_subnet_prefix
  tags                   = local.common_tags
  application_rules      = local.application_rules
  network_rules          = local.network_rules
  nat_rules              = local.nat_rules
}
