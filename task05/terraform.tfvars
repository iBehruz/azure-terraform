resource_groups = {
  rg1 = {
    name     = "cmaz-31zawnrd-mod5-rg-01"
    location = "East US"
  }
  rg2 = {
    name     = "cmaz-31zawnrd-mod5-rg-02"
    location = "West Europe"
  }
  rg3 = {
    name     = "cmaz-31zawnrd-mod5-rg-03"
    location = "Central US"
  }
}

app_service_plans = {
  asp1 = {
    name               = "cmaz-31zawnrd-mod5-asp-01"
    resource_group_key = "rg1"
    sku_name           = "S1"
    worker_count       = 2
  }
  asp2 = {
    name               = "cmaz-31zawnrd-mod5-asp-02"
    resource_group_key = "rg2"
    sku_name           = "S1"
    worker_count       = 1
  }
}

app_services = {
  app1 = {
    name                 = "cmaz-31zawnrd-mod5-app-01"
    resource_group_key   = "rg1"
    app_service_plan_key = "asp1"
    ip_restrictions = [
      {
        name       = "allow-ip"
        action     = "Allow"
        priority   = 100
        ip_address = "18.153.146.156/32"
      },
      {
        name        = "allow-tm"
        action      = "Allow"
        priority    = 200
        service_tag = "AzureTrafficManager"
      }
    ]
  }
  app2 = {
    name                 = "cmaz-31zawnrd-mod5-app-02"
    resource_group_key   = "rg2"
    app_service_plan_key = "asp2"
    ip_restrictions = [
      {
        name       = "allow-ip"
        action     = "Allow"
        priority   = 100
        ip_address = "18.153.146.156/32"
      },
      {
        name        = "allow-tm"
        action      = "Allow"
        priority    = 200
        service_tag = "AzureTrafficManager"
      }
    ]
  }
}

traffic_manager = {
  profile_name       = "cmaz-31zawnrd-mod5-traf"
  resource_group_key = "rg3"
  routing_method     = "Performance"
  dns_ttl            = 60
  monitor_protocol   = "HTTPS"
  monitor_port       = 443
  monitor_path       = "/"
}

tags = {
  Creator = "behroz_ilhomov@epam.com"
}

verification_agent_ip = "18.153.146.156"