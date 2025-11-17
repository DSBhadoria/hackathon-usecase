# Terraform configuration for Healthcare Application Infrastructure
# This is a starter template - customize according to your needs

terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Backend configuration for remote state storage
  # Uncomment and configure after creating storage account
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "tfstatehealthcare"
  #   container_name       = "tfstate"
  #   key                  = "dev.tfstate"
  # }
}

provider "azurerm" {
  features {}
}
