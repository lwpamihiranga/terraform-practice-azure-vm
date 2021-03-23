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

# Create virtual network
resource "azurerm_virtual_network" "practice_network" {
  name                = "terraform-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.practice_resource_group.location
  resource_group_name = azurerm_resource_group.practice_resource_group.name

  tags = {
    environment = "Terraform Practice"
  }
}