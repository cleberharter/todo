terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Partial config: resource_group_name, storage_account_name, container_name and key
  # are supplied via `terraform init -backend-config=...` (see .github/workflows/infra.yml).
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}
