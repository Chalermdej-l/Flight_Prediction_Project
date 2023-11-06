resource "azurerm_resource_group" "airline_resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_region
}

output "resource_group_name" {
  value = azurerm_resource_group.airline_resource_group.name
}
output "resource_group_region" {
  value = azurerm_resource_group.airline_resource_group.location
}