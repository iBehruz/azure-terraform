output "azure_firewall_public_ip" {
  description = "Public IP address of Azure Firewall"
  value       = module.afw.firewall_public_ip
}

output "azure_firewall_private_ip" {
  description = "Private IP address of Azure Firewall"
  value       = module.afw.firewall_private_ip
}

output "firewall_name" {
  description = "Name of the deployed Azure Firewall"
  value       = module.afw.firewall_name
}

output "nginx_access_url" {
  description = "URL to access NGINX through Azure Firewall"
  value       = "http://${module.afw.firewall_public_ip}"
}
