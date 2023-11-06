resource "azurerm_service_plan" "appservice_airline" {
  name                = "airlineAppServicePlan"
  location            = var.resource_group_region
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "EP1"

}

resource "azurerm_linux_function_app" "function_app" {
  name                = "airline-prediction"
  location                   = var.resource_group_region
  resource_group_name        = var.resource_group_name

  storage_account_name        = var.storage_name
  storage_account_access_key =  var.storage_key
  service_plan_id            = azurerm_service_plan.appservice_airline.id
  app_settings = {
    EVENT_HUB_CONNECTION_STR                 = var.consumer_connection_string
    EVENT_HUB_NAME                           = var.eventhub_consumer_name
    EVENT_HUB_CONSUMER_GROUP_EVENT           = var.consumer_group_consumer_name
    BLOB_STORAGE_CONNECTION_STRING           = var.consumer_connection_string
    BLOB_CONTAINER_NAME                      = var.consumer_container_name
    EVENT_HUB_CONNECTION_STR_OUT             = var.predict_connection_string
    EVENT_HUB_NAME_OUT                       = var.predict_container_name
  }
  site_config {
    application_stack {
        docker {
            registry_url = "${var.container_regis_name}.azurecr.io"
            image_name = var.container_image_name
            image_tag = var.image_tag
        }
        # python_version = 3.9
    }
  }
}
