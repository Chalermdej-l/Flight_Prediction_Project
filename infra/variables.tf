variable "resource_group_name" {
    type = string
}
variable "resource_group_region" {
    type = string
}
variable "blob_name_consumer" {
    type = string
}
variable "blob_name_predict" {
    type = string
}
variable "storage_account_name_consumer" {
    type = string
}
variable "storage_account_name_predict" {
    type = string
}
variable "eventhub_namespace" {
    type = string
}
variable "eventhub_name_consumer" {
    type = string
}
variable "eventhub_name_producer" {
    type = string
}
variable "eventhub_consumer_consumergroup" {
    type = string
}
variable "eventhub_producer_consumergroup" {
    type = string
}
variable "container_regis_name" {
    type = string
}
variable "container_image_name" {
    type = string
}
variable "storage_account_name_function" {
    type = string
}
variable "image_tag" {
    type = string
}
variable "docker_image" {
    type = string
}

