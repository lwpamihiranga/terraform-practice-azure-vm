terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "practice_resource_group" {
  name     = "terraform-resource-group"
  location = "eastus"

  tags = {
    environment = "Terraform Practice"
  }
}