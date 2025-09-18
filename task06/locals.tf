locals {
  # Resource names using Terraform functions
  rg_name         = format("%s-rg", var.name_prefix)
  sql_server_name = format("%s-sql", var.name_prefix)
  sql_db_name     = join("-", [var.name_prefix, "sql", "db"])
  asp_name        = format("%s-asp", var.name_prefix)
  app_name        = join("-", [var.name_prefix, "app"])

  # Key Vault secret names
  sql_admin_name_secret     = "sql-admin-name"
  sql_admin_password_secret = "sql-admin-password"

  # SQL Firewall rule name
  sql_firewall_rule_name = "allow-verification-ip"
}
