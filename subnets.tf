locals {
  subnet_name_prefix = "snet-${var.region_code}-${var.cluster_name}"
  subnet_cidrs = cidrsubnets(var.network_cidr, 4, 4, 4, 8, 8, 8)
  bastion_subnet_cidr = local.subnet_cidrs[3]
  application_gateway_subnet_cidr = local.subnet_cidrs[4]
  internal_loadbalancer_subnet_cidr = local.subnet_cidrs[5]
  system_pool_subnet_cidr = local.subnet_cidrs[0]
  user_pool_subnet_cidr = local.subnet_cidrs[1]
  data_subnet_cidr = local.subnet_cidrs[2]
}

# create a subnet for application gateway
resource azurerm_subnet agw {
  name = "${local.subnet_name_prefix}-agw"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.application_gateway_subnet_cidr]
}

# create a subnet for the internal loadbalancer managed by AKS
# TODO: do we need this?
resource azurerm_subnet ilb {
  name = "${local.subnet_name_prefix}-ilb"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.internal_loadbalancer_subnet_cidr]
}

# create a subnet for the bastion service
resource azurerm_subnet bastion {
  name = "${local.subnet_name_prefix}-bastion"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.bastion_subnet_cidr]
}

# create a subnet for the AKS system pool
resource azurerm_subnet system_pool {
  name = "${local.subnet_name_prefix}-system-pool"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.system_pool_subnet_cidr]
}

# create a subnet for the AKS user pool
resource azurerm_subnet user_pool {
  name = "${local.subnet_name_prefix}-user-pool"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.user_pool_subnet_cidr]
}

# create a subnet for optional database instances
resource azurerm_subnet data {
  name = "${local.subnet_name_prefix}-data"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.data_subnet_cidr]
}
