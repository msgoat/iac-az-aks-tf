# create a dedicated private DNS zone to manage all private DNS records of this cluster
resource azurerm_private_dns_zone cluster {
  name = "${var.cluster_name}.k8s.azure.msgoat.eu"
  resource_group_name = var.resource_group_name
  tags = merge(map("Name", "dnsz-${var.region_code}-${var.cluster_name}-private"), local.module_common_tags)
}

# link private DNS zone to VNet hosting the AKS cluster
resource azurerm_private_dns_zone_virtual_network_link cluster {
  name = "vnl-dnsz-${var.region_code}-${var.cluster_name}-private"
  virtual_network_id = azurerm_virtual_network.vnet.id
  resource_group_name = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cluster.name
}