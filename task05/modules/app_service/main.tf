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
    
    health_check_path = "/"
    
    use_32_bit_worker = false
    http2_enabled     = true
    ftps_state       = "FtpsOnly"
    
    minimum_tls_version = "1.2"
  }
  
  https_only = true
  
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "ASPNETCORE_ENVIRONMENT"      = "Production"
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = "true"
  }
  
  tags = var.tags
}
