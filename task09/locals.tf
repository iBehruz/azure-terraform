locals {
  common_tags = {
    Project     = "AKS-Security"
    ManagedBy   = "Terraform"
    Environment = "Production"
  }

  application_rules = [
    {
      name             = "allow-aks-required-fqdns"
      source_addresses = ["*"]
      target_fqdns = [
        "*.hcp.${lower(replace(var.location, " ", ""))}.azmk8s.io",
        "mcr.microsoft.com",
        "*.data.mcr.microsoft.com",
        "management.azure.com",
        "login.microsoftonline.com",
        "packages.microsoft.com",
        "acs-mirror.azureedge.net",
        "*.ubuntu.com",
        "api.snapcraft.io"
      ]
      protocols = [
        { port = "443", type = "Https" },
        { port = "80", type = "Http" }
      ]
    },
    {
      name             = "allow-docker-registry"
      source_addresses = ["*"]
      target_fqdns = [
        "*.docker.io",
        "docker.io",
        "registry-1.docker.io",
        "auth.docker.io",
        "production.cloudflare.docker.com"
      ]
      protocols = [
        { port = "443", type = "Https" },
        { port = "80", type = "Http" }
      ]
    }
  ]

  network_rules = [
    {
      name                  = "allow-dns"
      source_addresses      = ["*"]
      destination_ports     = ["53"]
      destination_addresses = ["*"]
      destination_fqdns     = []
      protocols             = ["UDP"]
    },
    {
      name                  = "allow-ntp"
      source_addresses      = ["*"]
      destination_ports     = ["123"]
      destination_addresses = []
      destination_fqdns     = ["ntp.ubuntu.com"]
      protocols             = ["UDP"]
    },
    {
      name                  = "allow-aks-tunnel"
      source_addresses      = ["*"]
      destination_ports     = ["9000", "22"]
      destination_addresses = ["AzureCloud.${replace(lower(var.location), " ", "")}"]
      destination_fqdns     = []
      protocols             = ["TCP"]
    }
  ]

  nat_rules = [
    {
      name              = "nginx-http"
      source_addresses  = ["*"]
      destination_ports = ["80"]
      translated_port   = 80
      protocols         = ["TCP"]
    },
    {
      name              = "nginx-https"
      source_addresses  = ["*"]
      destination_ports = ["443"]
      translated_port   = 443
      protocols         = ["TCP"]
    }
  ]
}
