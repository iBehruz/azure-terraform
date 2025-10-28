locals {
  firewall_name        = "${var.resource_prefix}-afw"
  firewall_pip_name    = "${var.resource_prefix}-pip"
  firewall_subnet_name = "AzureFirewallSubnet"
  route_table_name     = "${var.resource_prefix}-rt"

  common_tags = merge(
    var.tags,
    {
      ManagedBy   = "Terraform"
      Environment = "Production"
      Purpose     = "AKS-Security"
    }
  )
}
