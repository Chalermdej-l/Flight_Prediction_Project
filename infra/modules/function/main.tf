resource "azurerm_app_service_plan" "appservice_airline" {
  name                = "airlineAppServicePlan"
  location            = var.resource_group_region
  resource_group_name = var.resource_group_name
  sku {
    tier = "Premium"
    size = "EP1"
  }
}

# Create an Azure Function App with a custom container
resource "azurerm_function_app" "example" {
  name                       = "airline-prediction"
  location                   = var.resource_group_region
  resource_group_name        = var.resource_group_name
  app_service_plan_id         = azurerm_app_service_plan.appservice_airline.id
  storage_account_name        = var.storage_name
  storage_account_access_key =  var.storage_key
  os_type                    = "Linux"
  site_config {
    linux_fx_version = "DOCKER|" var.container_regis_name + ".io/" var.container_image_name +":" + var.image_tag
  }
}


# Define application settings for environment variables
resource "azurerm_function_app_app_settings" "example" {
  name                = azurerm_function_app.example.name
  resource_group_name = azurerm_function_app.example.resource_group_name

  app_settings = {
    EVENT_HUB_CONNECTION_STR                 = "your_event_hub_connection_str_value"
    EVENT_HUB_NAME                           = "your_event_hub_name"
    EVENT_HUB_CONSUMER_GROUP_EVENT  = "your_consumer_group_event"
    BLOB_STORAGE_CONNECTION_STRING = "your_blob_storage_connection_string"
    BLOB_CONTAINER_NAME                 = "your_blob_container_name"
    EVENT_HUB_CONNECTION_STR_OUT     = "your_event_hub_connection_str_out_value"
    EVENT_HUB_NAME_OUT                     = "your_event_hub_name_out"
  }
}

# Define custom container settings for the Docker container
resource "azurerm_function_app_docker" "example" {
  function_app_id = azurerm_function_app.example.id
  name           = "consumer"
  image_name     = "consumer"
  container_settings {
    command = ["python", "code/consumer.py"]
    registry = {
      server   = "your-container-registry-url"
      username = "your-registry-username"
      password = "your-registry-password"
    }
  }
}
