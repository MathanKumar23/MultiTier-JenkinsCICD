# resource_group_name = ""
vnet_name          = "terra_vnet"
vent_address_space = "198.168.0.0/16"
# if required to create multiple subnet, create using this list(object) type
subnets = {
  "subnet-1" = {
    name             = "subnet1"
    address_prefixes = "198.168.10.0/24"
  }
  #   "subnet2" = {
  #     name             = "subnet2"
  #     address_prefixes = "198.168.20.0/24"
  #   }
}
nsg_name = "terra_nsg"
nsg_rules = [
  {
    name                       = "AllowSSH"
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Allow80"
    priority                   = "110"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Allow8080"
    priority                   = "120"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Allow9000"
    priority                   = "130"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "9000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Allow8001"
    priority                   = "140"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

public_ip         = "10.0.0.10"
allocation_method = "Static"
nic_name          = "terraNic"
vm_name           = "terraVm"

#Standard_B4ms 4Cpus 16GBi , Standard_D2s_v3 # 2Cpus 8Gbi RAM
vm_size = "Standard_B4ms" # 2Cpus 8Gbi RAM

