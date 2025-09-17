resource "azurerm_windows_web_app" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id

  site_config {
    always_on = true

    ip_restriction_default_action = "Deny"

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions

      content {
        name        = ip_restriction.value.name
        action      = ip_restriction.value.action
        priority    = ip_restriction.value.priority
        ip_address  = ip_restriction.value.ip_address
        service_tag = ip_restriction.value.service_tag
      }
    }

    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }

    health_check_path                 = "/"
    health_check_eviction_time_in_min = 2

    use_32_bit_worker = false
    http2_enabled     = true
    ftps_state        = "FtpsOnly"

    minimum_tls_version = "1.2"

    default_documents = [
      "Default.htm",
      "Default.html",
      "Default.asp",
      "index.htm",
      "index.html",
      "iisstart.htm",
      "default.aspx",
      "index.php",
      "hostingstart.html"
    ]
  }

  https_only = false

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"        = "1"
    "ASPNETCORE_ENVIRONMENT"          = "Production"
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = "true"
    "WEBSITE_NODE_DEFAULT_VERSION"    = "6.9.1"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }
}