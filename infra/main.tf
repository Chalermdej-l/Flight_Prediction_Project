# Configure the Azure provider
provider "azurerm" {
  features {}
}

module "resourcegroup" {
  source = "./modules/resourcegroup"   
  resource_group_name      = var.resource_group_name
  resource_group_region    = var.resource_group_region
}

module "blob" {
  source = "./modules/blob"   
  resource_group_name      = module.resourcegroup.resource_group_name
  resource_group_region    = module.resourcegroup.resource_group_region
  blob_name_consumer       = var.blob_name_consumer
  blob_name_predict        = var.blob_name_predict
  storage_account_name_function        = var.storage_account_name_function
  storage_account_name_consumer    = var.storage_account_name_consumer
  storage_account_name_predict     = var.storage_account_name_predict 
}

module "eventhub" {
  source = "./modules/eventhub"   
  resource_group_name      = module.resourcegroup.resource_group_name
  resource_group_region    = module.resourcegroup.resource_group_region
  eventhub_namespace = var.eventhub_namespace 
  eventhub_name_consumer = var.eventhub_name_consumer 
  eventhub_name_producer = var.eventhub_name_producer 
  eventhub_consumer_consumergroup = var.eventhub_consumer_consumergroup 
  eventhub_producer_consumergroup = var.eventhub_producer_consumergroup 
 }

module "dockerregis" {
  source = "./modules/containerregis"   
  resource_group_name      = module.resourcegroup.resource_group_name
  resource_group_region    = module.resourcegroup.resource_group_region
  container_regis_name    =  var.container_regis_name
 }


# output "consumer_container_name" {
#   value = module.blob.consumer_container_name
# }
# output "predict_container_name" {
#   value = module.blob.predict_container_name
# }
# output "consumer_connection_string" {
#   value = module.blob.consumer_connection_string
#   sensitive = true
# }
# output "predict_connection_string" {
#   value = module.blob.predict_connection_string
#   sensitive = true
# }

# output "eventhub_consumer_listen_auth_rule" {
#   value = module.eventhub.eventhub_consumer_listen_auth_rule
#     sensitive = true
# }

# output "eventhub_consumer_send_auth_rule" {
#   value = module.eventhub.eventhub_consumer_send_auth_rule
#     sensitive = true
# }

# output "eventhub_producer_listen_auth_rule" {
#   value = module.eventhub.eventhub_producer_listen_auth_rule
#   sensitive = true
# }

# output "eventhub_producer_send_auth_rule" {
#   value = module.eventhub.eventhub_producer_send_auth_rule
#   sensitive = true 
# }

# output "eventhub_consumer_name" {
#   value = module.eventhub.eventhub_consumer_name
# }

# output "eventhub_producer_name" {
#   value = module.eventhub.eventhub_producer_name
# }

# output "consumer_group_consumer_name" {
#   value = module.eventhub.consumer_group_consumer_name
# }

# output "consumer_group_producer_name" {
#   value = module.eventhub.consumer_group_producer_name
# }
