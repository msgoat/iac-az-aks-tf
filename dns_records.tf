# create a DNS A record for all incoming "web.*" requests pointing to the loadbalancer

resource azurerm_dns_a_record apps {
  name = "apps"
  resource_group_name = var.resource_group_name
  zone_name = azurerm_dns_zone.cluster.name
  ttl = 300
  target_resource_id = azurerm_public_ip.cluster_agw.id
  tags = merge(map("Name", "dnsr-${var.region_code}-${var.cluster_name}-apps"), local.module_common_tags)
}

resource azurerm_dns_a_record traefik {
  name = "traefik"
  resource_group_name = var.resource_group_name
  zone_name = azurerm_dns_zone.cluster.name
  ttl = 300
  target_resource_id = azurerm_public_ip.cluster_agw.id
  tags = merge(map("Name", "dnsr-${var.region_code}-${var.cluster_name}-apps"), local.module_common_tags)
}
