output "sql_server_fqdn" {
  description = "SQL Server fully qualified domain name"
  value       = module.sql.sql_server_fqdn
}

output "app_hostname" {
  description = "Linux Web App hostname"
  value       = module.webapp.app_hostname
}
