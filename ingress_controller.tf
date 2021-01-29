# collect shared information about the actual ingress controller
locals {
  ingress_controller_dns = "ingress.${var.cluster_name}.k8s.azure.msgoat.eu"
  ingress_controller_ip = var.ingress_controller_type == "TRAEFIK" ? data.kubernetes_service.ingress_traefik[0].load_balancer_ingress[0].ip : (var.ingress_controller_type == "ISTIO" ? data.kubernetes_service.ingress_istio[0].load_balancer_ingress[0].ip : "")
}