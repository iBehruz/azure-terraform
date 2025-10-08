resource "azurerm_container_registry" "acr" {
  name                = "cmtr31zawnrdmod8cr"
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = "Basic"
  admin_enabled       = true
  provisioner "local-exec" {
    command = "az acr build --image cmtr-31zawnrd-mod8-app:latest --registry ${azurerm_container_registry.acr.name} --file application/Dockerfile application/ "
  }
}
