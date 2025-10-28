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

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# Route Table
resource "azurerm_route_table" "aks" {
  name                = local.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.common_tags

  route {
    name                   = "to-internet-via-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.main.ip_configuration[0].private_ip_address
  }
}

# Associate Route Table with AKS Subnet
resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = data.azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.aks.id
}

# Application Rule Collection - USED DYNAMIC BLOCKS
resource "azurerm_firewall_application_rule_collection" "aks" {
  name                = "aks-app-rules"
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
  name                = "aks-net-rules"
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
  name                = "nginx-nat-rules"
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
}
