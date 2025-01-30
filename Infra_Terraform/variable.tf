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

#################

variable "env" {
  type        = string
  description = "The environment (e.g., dev, staging, prod) where resources will be deployed."
}

variable "cluster_name" {
  type        = string
  description = "The name of your AKS cluster (lowercase letters, numbers, hyphens, 1-12 characters)"
}

variable "cluster_version" {
  type        = string
  description = "The version of Kubernetes for the AKS cluster."
}

variable "is_aks_cluster_enabled" {
  type        = bool
  description = "Flag to enable or disable the AKS cluster creation."
}

variable "private_cluster_enabled" {
  description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "default_node_count" {
  type        = number
  description = "The number of default nodes in the AKS cluster."
}

variable "default_vm_size" {
  type        = string
  description = "The size of the VM for the default node pool."
}

variable "authorized_ip_ranges" {
  type        = set(string)
  description = "List of authorized IP ranges for API server access."
  default     = []
}
