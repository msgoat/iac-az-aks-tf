# deploys Azure AD Pod Identity controller on AKS cluster
resource helm_release aad_pod_identity {
  count = 1
  name = "aad-pod-identity"
  chart = "aad-pod-identity"
  version = "3.0.0"
  namespace = "aad-pod-identity"
  create_namespace = true
  dependency_update = true
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  atomic = true
  cleanup_on_fail = true
/*
  values = [file("${path.module}/resources/helm/aad-pod-identity/values.yaml")]
  set {
    name = "adminsecret.cloud"
    value = "AZUREPUBLICCLOUD"
    type = "string"
  }
  set {
    name = "adminsecret.tenantID"
    value = data.azurerm_client_config.current.tenant_id
    type = "string"
  }
  set {
    name = "adminsecret.subscriptionID"
    value = data.azurerm_client_config.current.subscription_id
    type = "string"
  }
  set {
    name = "adminsecret.resourceGroup"
    value = azurerm_user_assigned_identity.pod_identity.resource_group_name
    type = "string"
  }
  set {
    name = "adminsecret.vmType"
    value = "vmss"
    type = "string"
  }
  set {
    name = "adminsecret.clientID"
    value = "msi"
    type = "string"
  }
  set {
    name = "adminsecret.clientSecret"
    value = "msi"
    type = "string"
  }
  set {
    name = "adminsecret.useMSI"
    value = "true"
    type = "string"
  }
  set {
    name = "adminsecret.userAssignedMSIClientID"
    value = azurerm_user_assigned_identity.pod_identity.client_id
    type = "string"
  }
  depends_on = [null_resource.wait_for_role_assignments_to_pod_identity]
*/
}
