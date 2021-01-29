locals {
  ingress_traefik_enabled = var.ingress_controller_type == "TRAEFIK" ? true : false
}

# deploys ingress controller traefik with public IP using an external loadbalancer
resource helm_release traefik_public {
  count = local.ingress_traefik_enabled && var.loadbalancer_type == "EXTERNAL" ? 1 : 0
  name = "k8s-ingress"
  chart = "traefik"
  version = "9.11.0"
  namespace = "k8s-ingress"
  create_namespace = true
  dependency_update = true
  repository = "https://helm.traefik.io/traefik"
  atomic = true
  cleanup_on_fail = true
  values = [file("${path.module}/resources/helm/traefik/values.yaml")]
}

# deploys ingress controller traefik with public IP using an external loadbalancer
resource helm_release traefik_private {
  count = local.ingress_traefik_enabled && var.loadbalancer_type == "INTERNAL" ? 1 : 0
  name = "k8s-ingress"
  chart = "traefik"
  version = "9.11.0"
  namespace = "k8s-ingress"
  create_namespace = true
  dependency_update = true
  repository = "https://helm.traefik.io/traefik"
  atomic = true
  cleanup_on_fail = true
  values = [file("${path.module}/resources/helm/traefik/values.yaml"), templatefile("${path.module}/resources/helm/traefik/values-internal-loadbalancer.tpl.yaml", { tf_loadbalancer_subnet_name = azurerm_subnet.ilb.name })]
}

# retrieve external ip assigned to the ingress controller service
data kubernetes_service ingress_traefik {
  count = local.ingress_traefik_enabled ? 1 : 0
  metadata {
    name = "k8s-ingress-traefik"
    namespace = "k8s-ingress"
  }
  depends_on = [helm_release.traefik_public, helm_release.traefik_private]
}

# create public DNS record for ingress controller ip
resource azurerm_dns_a_record ingress_traefik {
  count = local.ingress_traefik_enabled && var.loadbalancer_type == "EXTERNAL" ? 1 : 0
  name = "ingress"
  resource_group_name = azurerm_dns_zone.cluster.resource_group_name
  zone_name = azurerm_dns_zone.cluster.name
  ttl = 3600
  records = [data.kubernetes_service.ingress_traefik[0].load_balancer_ingress[0].ip]
}

# create private DNS record for ingress controller ip
resource azurerm_private_dns_a_record ingress_traefik {
  count = local.ingress_traefik_enabled && var.loadbalancer_type == "INTERNAL" ? 1 : 0
  name = "ingress"
  resource_group_name = azurerm_private_dns_zone.cluster.resource_group_name
  zone_name = azurerm_private_dns_zone.cluster.name
  ttl = 3600
  records = [data.kubernetes_service.ingress_traefik[0].load_balancer_ingress[0].ip]
}



