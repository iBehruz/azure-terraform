# Data source for existing resources
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

# Azure Firewall Subnet
resource "azurerm_subnet" "firewall" {
  name                 = local.firewall_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.firewall_subnet_prefix]
}

# Public IP for Azure Firewall
resource "azurerm_public_ip" "firewall" {
  name                = local.firewall_pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

# Azure Firewall
resource "azurerm_firewall" "main" {
  name                = local.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  zones               = ["1", "2", "3"]
  tags                = local.common_tags
  dns_proxy_enabled   = true


  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# Route Table
resource "azurerm_route_table" "aks" {
  name                          = local.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tags                          = local.common_tags

  route {
    name                   = "to-internet-via-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.main.ip_configuration[0].private_ip_address
  }

  depends_on = [azurerm_firewall.main]
}

# Associate Route Table with AKS Subnet
resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = data.azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.aks.id

  depends_on = [azurerm_route_table.aks]
}
# Application Rule Collection - USED DYNAMIC BLOCKS
resource "azurerm_firewall_application_rule_collection" "aks" {
  name                = local.app_rule_collection_name
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  dynamic "rule" {
    for_each = var.application_rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      target_fqdns     = rule.value.target_fqdns

      dynamic "protocol" {
        for_each = rule.value.protocols
        content {
          port = protocol.value.port
          type = protocol.value.type
        }
      }
    }
  }
}

# Network Rule Collection - USED DYNAMIC BLOCKS
resource "azurerm_firewall_network_rule_collection" "aks" {
  name                = local.net_rule_collection_name
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  dynamic "rule" {
    for_each = var.network_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = length(rule.value.destination_addresses) > 0 ? rule.value.destination_addresses : null
      destination_fqdns     = length(rule.value.destination_fqdns) > 0 ? rule.value.destination_fqdns : null
      protocols             = rule.value.protocols
    }
  }
}

# NAT Rule Collection - USED DYNAMIC BLOCKS AND FOR_EACH
resource "azurerm_firewall_nat_rule_collection" "nginx" {
  name                = local.nat_rule_collection_name
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Dnat"

  dynamic "rule" {
    for_each = var.nat_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = [azurerm_public_ip.firewall.ip_address]
      translated_port       = rule.value.translated_port
      translated_address    = var.aks_loadbalancer_ip
      protocols             = rule.value.protocols
    }
  }

  depends_on = [azurerm_public_ip.firewall]
}

# Data source for AKS cluster
data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

# Data source for AKS NSG
data "azurerm_network_security_group" "aks" {
  name                = "aks-agentpool-${data.azurerm_kubernetes_cluster.aks.node_resource_group_id}-nsg"
  resource_group_name = data.azurerm_kubernetes_cluster.aks.node_resource_group
}

# NSG Rule to allow traffic from Firewall to Load Balancer
resource "azurerm_network_security_rule" "allow_firewall_to_lb" {
  name                        = "AllowAccessFromFirewallPublicIPToLoadBalancerIP"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = azurerm_public_ip.firewall.ip_address
  destination_address_prefix  = var.aks_loadbalancer_ip
  resource_group_name         = data.azurerm_kubernetes_cluster.aks.node_resource_group
  network_security_group_name = data.azurerm_network_security_group.aks.name

  depends_on = [azurerm_firewall.main, azurerm_public_ip.firewall]
}
