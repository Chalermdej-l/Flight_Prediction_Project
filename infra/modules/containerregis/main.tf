resource "azurerm_container_registry" "airlineregis" {
  name                     = var.container_regis_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_region
  sku                      = "Basic"
  admin_enabled            = true
}