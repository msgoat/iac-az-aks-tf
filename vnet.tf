locals {
  vnet_name_prefix = "vnet-${var.region_code}"
  vnet_name = "${local.vnet_name_prefix}-${var.cluster_name}"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name = local.vnet_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  address_space = [var.network_cidr]
  tags = merge(map("Name", local.vnet_name), local.module_common_tags)
}
