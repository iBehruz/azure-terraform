name_prefix           = "cmaz-31zawnrd-mod6"
location              = "West US"
existing_kv_rg_name   = "cmaz-31zawnrd-mod6-kv-rg"
existing_kv_name      = "cmaz-31zawnrd-mod6-kv"
sql_admin_username    = "sqladmin"
sql_db_sku            = "S2"
asp_sku               = "P0v3"
webapp_dotnet_version = "8.0"

# Update this to your public IP for local development
# For verification, use: 18.153.146.156
allowed_ip_address = "18.153.146.156"

tags = {
  Creator = "behroz_ilhomov@epam.com"
}
