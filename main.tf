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

# Create subnet in the virtual network
resource "azurerm_subnet" "practice_subnet" {
  name                  = "terraform-subnet"
  resource_group_name   = azurerm_resource_group.practice_resource_group.name
  virtual_network_name  = azurerm_virtual_network.practice_network.name
  address_prefixes      = [ "10.0.2.0/24" ]
}

# Create public IP address
resource "azurerm_public_ip" "practice_public_ip" {
  name = "terraform-public-ip"
  location = azurerm_resource_group.practice_resource_group.location
  resource_group_name = azurerm_resource_group.practice_resource_group.name
  allocation_method = "Dynamic"

  tags = {
    environment = "Terraform Practice"
  }
}