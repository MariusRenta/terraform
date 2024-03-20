# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "renta_rg" {
  name     = "RentaResourceGroup"
  location = "West Europe"
}

# Virtual network
resource "azurerm_virtual_network" "renta_network" {
  name                = "renta-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.renta_rg.location
  resource_group_name = azurerm_resource_group.renta_rg.name
}

# Subnet
resource "azurerm_subnet" "renta_subnet" {
  name                 = "renta-subnet"
  resource_group_name  = azurerm_resource_group.renta_rg.name
  virtual_network_name = azurerm_virtual_network.renta_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Virtual machines
resource "azurerm_virtual_machine" "renta_vm" {
  count                 = var.vm_count
  name                  = "renta-vm-${count.index}"
  location              = azurerm_resource_group.renta_rg.location
  resource_group_name   = azurerm_resource_group.renta_rg.name
  network_interface_ids = [azurerm_network_interface.renta_nic[count.index].id]
  vm_size               = var.vm_flavor

  # This provisioner executes a Bash command on the remote Azure virtual machine.
  provisioner "remote-exec" {
    inline = [
      "ssh -i ${var.private_key_path} -o StrictHostKeyChecking=no ${var.admin_username}@${element(azurerm_network_interface.renta_nic.*.private_ip_address, count.index)} 'ping -c 1 ${element(azurerm_network_interface.renta_nic.*.private_ip_address, 0)}'"
    ]
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "hostname-${count.index}"
    admin_username = var.admin_username
    admin_password = random_password.renta_pw[count.index].result
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "testing"
  }
}

# Null resource for managing ping results
resource "null_resource" "ping_between_vms" {
  depends_on = [azurerm_virtual_machine.renta_vm]
  # Configurațiile pentru resursa null_resource aici
}

# Network interfaces
resource "azurerm_network_interface" "renta_nic" {
  count               = var.vm_count
  name                = "renta-nic-${count.index}"
  location            = azurerm_resource_group.renta_rg.location
  resource_group_name = azurerm_resource_group.renta_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.renta_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Generate random passwords for VMs using the random_password resource. 
# The number of passwords generated is determined by the vm_count variable, and each password has a length of 16 characters.
resource "random_password" "renta_pw" {
  count  = var.vm_count
  length = 16
}
