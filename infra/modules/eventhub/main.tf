resource "azurerm_eventhub_namespace" "airline" {
  name                = var.eventhub_namespace
  resource_group_name = var.resource_group_name
  location            = var.resource_group_region
  capacity            = 1
  sku = "Standard"
}

resource "azurerm_eventhub" "eventhub_consumer" {
  name                = var.eventhub_name_consumer
  namespace_name      = azurerm_eventhub_namespace.airline.name
  resource_group_name = var.resource_group_name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub" "eventhub_producer" {
  name                = var.eventhub_name_producer
  namespace_name      = azurerm_eventhub_namespace.airline.name
  resource_group_name = var.resource_group_name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "consumer_group_consumer" {
  name                = var.eventhub_consumer_consumergroup
  eventhub_name       = azurerm_eventhub.eventhub_consumer.name
  namespace_name      = azurerm_eventhub_namespace.airline.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_eventhub_consumer_group" "consumer_group_producer" {
  name                = var.eventhub_producer_consumergroup
  eventhub_name       = azurerm_eventhub.eventhub_producer.name
  namespace_name      = azurerm_eventhub_namespace.airline.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_eventhub_authorization_rule" "eventhub_consumer_listen" {
  name                = "consumer-key"
  namespace_name      = azurerm_eventhub_namespace.airline.name
  eventhub_name       = azurerm_eventhub.eventhub_consumer.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "eventhub_consumer_send" {
  name                = "producer-key"
  namespace_name      = azurerm_eventhub_namespace.airline.name
  eventhub_name       = azurerm_eventhub.eventhub_consumer.name
  resource_group_name = var.resource_group_name
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "eventhub_producer_listen" {
  name                = "consumer-key"
  namespace_name      = azurerm_eventhub_namespace.airline.name
  eventhub_name       = azurerm_eventhub.eventhub_producer.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "eventhub_producer_send" {
  name                = "producer-key"
  namespace_name      = azurerm_eventhub_namespace.airline.name
  eventhub_name       = azurerm_eventhub.eventhub_producer.name
  resource_group_name = var.resource_group_name
  listen              = false
  send                = true
  manage              = false
}

output "eventhub_consumer_listen_auth_rule" {
  value = azurerm_eventhub_authorization_rule.eventhub_consumer_listen
}

output "eventhub_consumer_send_auth_rule" {
  value = azurerm_eventhub_authorization_rule.eventhub_consumer_send
}

output "eventhub_producer_listen_auth_rule" {
  value = azurerm_eventhub_authorization_rule.eventhub_producer_listen
}

output "eventhub_producer_send_auth_rule" {
  value = azurerm_eventhub_authorization_rule.eventhub_producer_send
}

output "eventhub_consumer_name" {
  value = azurerm_eventhub.eventhub_consumer.name
}

output "eventhub_producer_name" {
  value = azurerm_eventhub.eventhub_producer.name
}

output "consumer_group_consumer_name" {
  value = azurerm_eventhub_consumer_group.consumer_group_consumer.name
}

output "consumer_group_producer_name" {
  value = azurerm_eventhub_consumer_group.consumer_group_producer.name
}
