resource_group_name = "cmaz-31zawnrd-mod4-rg"
location            = "East US"
vnet_name           = "cmaz-31zawnrd-mod4-vnet"
subnet_name         = "frontend"
nic_name            = "cmaz-31zawnrd-mod4-nic"
nsg_name            = "cmaz-31zawnrd-mod4-nsg"
nsg_rule_http       = "AllowHTTP"
nsg_rule_ssh        = "AllowSSH"
public_ip_name      = "cmaz-31zawnrd-mod4-pip"
domain_name_label   = "cmaz-31zawnrd-mod4-nginx"
vm_name             = "cmaz-31zawnrd-mod4-vm"
vm_os_version       = "24_04-lts"
vm_sku              = "Standard_F2s_v2"
vm_username         = "azureuser"

tags = {
  Creator = "behroz_ilhomov@epam.com"
}
