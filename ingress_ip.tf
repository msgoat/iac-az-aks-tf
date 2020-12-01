# retrieve external ip assigned to the ingress controller service
data kubernetes_service ingress {
  metadata {
    name = "k8s-ingress-traefik"
    namespace = "k8s-ingress"
  }
  depends_on = [helm_release.ingress]
}

output ingress_ip_address {
  value = data.kubernetes_service.ingress.load_balancer_ingress[0].ip
}
