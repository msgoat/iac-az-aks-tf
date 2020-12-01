# deploys ingress controller traefik with helm
resource helm_release ingress {
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
 # depends_on = [kubernetes_service.internal_lb]
}
