locals {
  ingress_istio_enabled = var.ingress_controller_type == "ISTIO" ? true : false
}

# deploys Istio base with helm
resource helm_release istio_base {
  count = local.ingress_istio_enabled ? 1 : 0
  name = "istio-base"
  chart = "${path.module}/resources/helm/istio/charts/base"
  version = "1.1.0"
  namespace = "istio-system"
  create_namespace = true
  atomic = true
  cleanup_on_fail = true
  values = [file("${path.module}/resources/helm/istio/charts/base/values.yaml")]
}

# deploys Istio discovery with helm
resource helm_release istio_discovery {
  count = local.ingress_istio_enabled ? 1 : 0
  name = "istio-discovery"
  chart = "${path.module}/resources/helm/istio/charts/istio-control/istio-discovery"
  namespace = "istio-system"
  create_namespace = true
  atomic = true
  cleanup_on_fail = true
  values = [file("${path.module}/resources/helm/istio/istio-discovery-values.yaml")]
}

# deploys Istio ingress gateway with helm using external loadbalancer with public IP addresses
resource helm_release istio_ingress_gateway_public {
  count = local.ingress_istio_enabled && var.loadbalancer_type == "EXTERNAL" ? 1 : 0
  name = "istio-ingress"
  chart = "${path.module}/resources/helm/istio/charts/gateways/istio-ingress"
  namespace = "istio-system"
  create_namespace = true
  atomic = true
  cleanup_on_fail = true
  values = [file("${path.module}/resources/helm/istio/istio-ingress-values.yaml")]
  depends_on = [helm_release.istio_base]
}

# deploys Istio ingress gateway with helm using internal loadbalancer with private IP addresses
resource helm_release istio_ingress_gateway_private {
  count = local.ingress_istio_enabled && var.loadbalancer_type == "INTERNAL" ? 1 : 0
  name = "istio-ingress"
  chart = "${path.module}/resources/helm/istio/charts/gateways/istio-ingress"
  namespace = "istio-system"
  create_namespace = true
  atomic = true
  cleanup_on_fail = true
  values = [file("${path.module}/resources/helm/istio/istio-ingress-values.yaml"), templatefile("${path.module}/resources/helm/istio/istio-ingress-values-internal-loadbalancer.tpl.yaml", { tf_loadbalancer_subnet_name = azurerm_subnet.ilb.name })]
  depends_on = [helm_release.istio_base]
}

# deploys Istio egress gateway with helm
resource helm_release istio_egress_gateway {
  count = local.ingress_istio_enabled ? 1 : 0
  name = "istio-egress"
  chart = "${path.module}/resources/helm/istio/charts/gateways/istio-egress"
  namespace = "istio-system"
  create_namespace = true
  atomic = true
  cleanup_on_fail = true
  values = [file("${path.module}/resources/helm/istio/istio-egress-values.yaml")]
  depends_on = [helm_release.istio_base, helm_release.istio_discovery]
}

# retrieve loadbalancer IP assigned to the istio ingress gateway service
data kubernetes_service ingress_istio {
  count = local.ingress_istio_enabled ? 1 : 0
  metadata {
    name = "istio-ingressgateway"
    namespace = "istio-system"
  }
  depends_on = [helm_release.istio_ingress_gateway_public, helm_release.istio_ingress_gateway_private]
}

# create public DNS record for ingress controller ip
resource azurerm_dns_a_record ingress_istio {
  count = local.ingress_istio_enabled && var.loadbalancer_type == "EXTERNAL" ? 1 : 0
  name = "ingress"
  resource_group_name = azurerm_dns_zone.cluster.resource_group_name
  zone_name = azurerm_dns_zone.cluster.name
  ttl = 3600
  records = [data.kubernetes_service.ingress_istio[0].load_balancer_ingress[0].ip]
}

# create private DNS record for ingress controller ip
resource azurerm_private_dns_a_record ingress_istio {
  count = local.ingress_istio_enabled && var.loadbalancer_type == "INTERNAL" ? 1 : 0
  name = "ingress"
  resource_group_name = azurerm_private_dns_zone.cluster.resource_group_name
  zone_name = azurerm_private_dns_zone.cluster.name
  ttl = 3600
  records = [data.kubernetes_service.ingress_istio[0].load_balancer_ingress[0].ip]
}

