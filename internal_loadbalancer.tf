# tell AKS to create an internal loadbalancer using private IPs only
# does not work since the App Service managed identity does not have the permissions
# to read information about our VNet
resource kubernetes_service internal_lb {
  count = var.loadbalancer_type == "INTERNAL" ? 1 : 0
  metadata {
    name = "internal-app"
    annotations = {
      "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
      "service.beta.kubernetes.io/azure-load-balancer-internal-subnet" = azurerm_subnet.ilb.name
    }
  }
  spec {
    type = "LoadBalancer"
    port {
      name = "http"
      port = 80
    }
    selector = {
      "app" = "internal-app"
    }
  }
  timeouts {
    create = "3m"
  }
}
