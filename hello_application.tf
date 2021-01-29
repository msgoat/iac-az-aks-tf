resource kubernetes_namespace hello {
  metadata {
    name = "hello"
    labels = {
      "istio-injection" = local.ingress_istio_enabled ? "enabled" : "disabled"
    }
  }
}

# deploys a hello application with helm
resource helm_release hello {
  name = "k8s-hello"
  chart = "${path.module}/resources/helm/hello"
  namespace = kubernetes_namespace.hello.metadata[0].name
  atomic = true
  cleanup_on_fail = true
  values = [file("${path.module}/resources/helm/hello/values.yaml")]
  # depends_on = [helm_release.ingress_traefik_public, helm_release.ingress_traefik_private]
}
