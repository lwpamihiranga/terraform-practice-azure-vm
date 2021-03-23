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

# Create network security group
resource "azurerm_network_security_group" "practice_security_group" {
  name = "terraform-security-group"
  location = azurerm_resource_group.practice_resource_group.location
  resource_group_name = azurerm_resource_group.practice_resource_group.name

  security_rule = [ {
    access = "Allow"
    #description = "value"
    destination_address_prefix = "*"
    # destination_address_prefixes = [ "value" ]
    # destination_application_security_group_ids = [ "value" ]
    destination_port_range = "22"
    # destination_port_ranges = [ "value" ]
    direction = "Inbound"
    name = "SSH"
    priority = 1001
    protocol = "TCP"
    source_address_prefix = "*"
    # source_address_prefixes = [ "value" ]
    # source_application_security_group_ids = [ "value" ]
    source_port_range = "*"
    # source_port_ranges = [ "value" ]
  } ]

  tags = {
    environment = "Terraform Practice"
  }
}

# Create virtual network interface card
resource "azurerm_network_interface" "practice_nic" {
  name = "terraform-nic"
  location = azurerm_resource_group.practice_resource_group.location
  resource_group_name = azurerm_resource_group.practice_resource_group.name

  ip_configuration {
    name = "terraform-nic-config"
    subnet_id = azurerm_subnet.practice_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.practice_public_ip.id
  }

  tags = {
    environment = "Terraform Practice"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "practice_connection" {
    network_interface_id      = azurerm_network_interface.practice_nic.id
    network_security_group_id = azurerm_network_security_group.practice_security_group.id
}

# Private SSH key
resource "tls_private_key" "practice_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Display the SSH key as output
output "tls_private_key" { value = tls_private_key.practice_ssh.private_key_pem }