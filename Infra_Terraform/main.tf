# terraform block to mention specific version if provider and terraform version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  # provide specific terraform version if any
  # required_version = "1.6"
}

# Configure the provider
provider "azurerm" {
  features {}
}

# Use the Data source block, if need to use already provisioned resiurces from the cloud
data "azurerm_resource_group" "rg" {
  name = "Example_terra"
}

# resource "azurerm_resource_group" "rg" {
#     name = var.resource_group_name
#     location = var.location
# }

resource "azurerm_virtual_network" "vent" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = [var.vent_address_space]
}

resource "azurerm_subnet" "subnet" {
  # loop thrigh subnets and get name and address prfixes from map or set of objects
  for_each             = var.subnets
  name                 = each.value.name
  address_prefixes     = [each.value.address_prefixes]
  virtual_network_name = azurerm_virtual_network.vent.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  # using dynamic bloock creste multiple nsg rules as needed
  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "publicip" {
  name                = var.public_ip
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = var.allocation_method
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "nic_configuration"
    subnet_id                     = lookup(azurerm_subnet.subnet, "subnet-1").id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  network_interface_ids = azurerm_network_interface.nic.id
  size                  = var.vm_size
  admin_username        = "azureuser"

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("./pemkey.pem")
  }
  user_data = filebase64("./userdata.tpl")
}
