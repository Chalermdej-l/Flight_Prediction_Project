resource "azurerm_storage_account" "airline_storage_account_consumer" {
  name                     = var.storage_account_name_consumer
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_region
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action             = "Allow"
    virtual_network_subnet_ids = []
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_storage_account" "airline_storage_account_predict" {
  name                     = var.storage_account_name_predict
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_region
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action             = "Allow"
    virtual_network_subnet_ids = []
  }

  lifecycle {
    prevent_destroy = false
  }
}

# resource "azurerm_storage_account" "airline_function_app" {
#   name                     = var.storage_account_name_function
#   resource_group_name      = var.resource_group_name
#   location                 = var.resource_group_region
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   lifecycle {
#     prevent_destroy = false
#   }
# }


resource "azurerm_storage_container" "airline_storage_consumer" {
  name                  = var.blob_name_consumer
  storage_account_name  = azurerm_storage_account.airline_storage_account_consumer.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "airline_storage_predict" {
  name                  = var.blob_name_predict
  storage_account_name  = azurerm_storage_account.airline_storage_account_predict.name
  container_access_type = "private"
}

output "consumer_container_name" {
    value = azurerm_storage_container.airline_storage_consumer.name
}
output "predict_container_name" {
    value = azurerm_storage_container.airline_storage_predict.name
}
output "consumer_connection_string" {
    value = azurerm_storage_account.airline_storage_account_consumer.primary_connection_string
}
output "predict_connection_string" {
    value = azurerm_storage_account.airline_storage_account_predict.primary_connection_string
}

# output "function_name" {
#     value = azurerm_storage_account.airline_function_app.name
# }
# output "function_key" {
#     value = azurerm_storage_account.airline_function_app.primary_access_key
# }