resource_group_name  = "cmaz-31zawnrd-mod3-rg"
storage_account_name = "cmaz31zawnrdsa"
vnet_name            = "cmaz-31zawnrd-mod3-vnet"
location             = "East US"

vnet_address_space = ["10.0.0.0/16"]

subnet_frontend_name   = "frontend"
subnet_frontend_prefix = "10.0.1.0/24"

subnet_backend_name   = "backend"
subnet_backend_prefix = "10.0.2.0/24"

tags = {
  Creator = "behroz_ilhomov@epam.com"
}
