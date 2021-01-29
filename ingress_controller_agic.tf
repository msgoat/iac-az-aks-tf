# deploys Application Gateway Ingress Controller on AKS cluster
resource helm_release agic {
  count = 1
  name = "ingress-azure"
  chart = "ingress-azure"
  version = "1.2.1"
  namespace = "ingress-agic"
  create_namespace = true
  dependency_update = true
  repository = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  atomic = true
  cleanup_on_fail = true
  set {
    name = "appgw.environment"
    value = "AZUREPUBLICCLOUD"
    type = "string"
  }
  set {
    name = "appgw.subscriptionId"
    value = data.azurerm_client_config.current.subscription_id
    type = "string"
  }
  set {
    name = "appgw.resourceGroup"
    value = azurerm_application_gateway.cluster_agw.resource_group_name
    type = "string"
  }
  set {
    name = "appgw.name"
    value = azurerm_application_gateway.cluster_agw.name
    type = "string"
  }
  set {
    name = "appgw.usePrivateIP"
    value = "false"
    type = "string"
  }
  set {
    name = "appgw.subResourceNamePrefix"
    value = var.cluster_name
    type = "string"
  }
  set {
    name = "armAuth.type"
    value = "aadPodIdentity"
    type = "string"
  }
  set {
    name = "armAuth.identityResourceID"
    value = azurerm_user_assigned_identity.agic.id
    type = "string"
  }
  set {
    name = "armAuth.identityClientID"
    value = azurerm_user_assigned_identity.agic.client_id
    type = "string"
  }
  set {
    name = "rbac.enabled"
    value = "true"
    type = "string"
  }
  depends_on = [helm_release.aad_pod_identity, null_resource.wait_for_role_assignments_to_agic]
}
