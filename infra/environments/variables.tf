variable "environment" {
  type        = string
  description = "Nome do ambiente: staging, hml ou production"
}

variable "location" {
  type    = string
  # brazilsouth não suporta Microsoft.Web/staticSites, por isso eastus2.
  default = "eastus2"
}

variable "project_name" {
  type    = string
  default = "todo"
}

variable "image_tag" {
  type        = string
  description = "Tag da imagem Docker do backend a ser implantada"
}

variable "app_service_sku" {
  type    = string
  default = "B1"
}

variable "app_service_worker_count" {
  type    = number
  default = 1
}

variable "static_web_app_sku_tier" {
  type    = string
  default = "Free"
}

# Localização do remote state do stack "shared" (RG + ACR), usado via terraform_remote_state.
variable "tfstate_resource_group_name" {
  type = string
}

variable "tfstate_storage_account_name" {
  type = string
}

variable "tfstate_container_name" {
  type = string
}
