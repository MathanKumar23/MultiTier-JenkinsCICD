# variable "resource_group_name" {}
variable "vnet_name" {}
variable "vent_address_space" {}
variable "subnets" {
  type = map(object({
    name             = string
    address_prefixes = string
  }))
}
variable "nsg_name" {}
variable "nsg_rules" {
  type = list(object({
    # required to mention type here as we have different types here which need to taken as attributes
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "public_ip" {}
variable "allocation_method" {}
variable "nic_name" {}
variable "vm_name" {}
variable "vm_size" {}
