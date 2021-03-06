resource azurerm_application_gateway cluster_agw {
  name = "agw-${var.region_code}-${var.cluster_name}"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  tags = merge(map("Name", "agw-${var.region_code}-${var.cluster_name}"), local.module_common_tags)

  backend_address_pool {
    name = "bap-${var.region_code}-${var.cluster_name}"
    ip_addresses = [data.kubernetes_service.ingress.load_balancer_ingress[0].ip]
  }

  backend_http_settings {
    name = "bhs-${var.region_code}-${var.cluster_name}"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
    request_timeout = 30
    probe_name = "agw-${var.region_code}-${var.cluster_name}-traefik"
  }

  frontend_ip_configuration {
    name = "agw-${var.region_code}-${var.cluster_name}-feipc"
    public_ip_address_id = azurerm_public_ip.cluster_agw.id
  }

  frontend_port {
    name = "agw-${var.region_code}-${var.cluster_name}-https"
    port = 443
  }

  gateway_ip_configuration {
    name = "agw-${var.region_code}-${var.cluster_name}-gwipc"
    subnet_id = azurerm_subnet.agw.id
  }

  http_listener {
    name = "agw-${var.region_code}-${var.cluster_name}-https"
    frontend_ip_configuration_name = "agw-${var.region_code}-${var.cluster_name}-feipc"
    frontend_port_name = "agw-${var.region_code}-${var.cluster_name}-https"
    protocol = "Https"
    ssl_certificate_name = "agw-${var.region_code}-${var.cluster_name}-ssl"
    host_name = "${var.cluster_name}.k8s.azure.msgoat.eu"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.cluster_agw.id]
  }

  probe {
    name = "agw-${var.region_code}-${var.cluster_name}-traefik"
    protocol = "Http"
    host = data.kubernetes_service.ingress.load_balancer_ingress[0].ip
    port = 80
    path = "/ping"
    # since the ingress endpoint for ping is not exposed we will get always 404
    match {
      status_code = [404]
    }
    interval = 30
    timeout = 5
    unhealthy_threshold = 3
  }

  request_routing_rule {
    name = "rrr-${var.region_code}-${var.cluster_name}-https"
    http_listener_name = "agw-${var.region_code}-${var.cluster_name}-https"
    rule_type = "Basic"
    backend_address_pool_name = "bap-${var.region_code}-${var.cluster_name}"
    backend_http_settings_name = "bhs-${var.region_code}-${var.cluster_name}"
  }

  ssl_certificate {
    name = "agw-${var.region_code}-${var.cluster_name}-ssl"
    key_vault_secret_id = azurerm_key_vault_certificate.cluster_agw.secret_id
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
    capacity = 2
  }
}

# create a public IP for the loadbalancer
resource azurerm_public_ip cluster_agw {
  name = "pip-${var.region_code}-${var.cluster_name}-agw"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = "k8s-${var.cluster_name}"
  # reverse_fqdn = "web.${azurerm_dns_zone.solution.name}"
  tags = merge(map("Name", "pip-${var.region_code}-${var.cluster_name}-agw"), local.module_common_tags)
}

# create an user-assigned identity to grant key vault access to application gateway
resource azurerm_user_assigned_identity cluster_agw {
  name = "id-${var.region_code}-${var.cluster_name}-agw"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
}
