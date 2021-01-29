# create a managed identity for the Application Gateway Ingress Controller (AGIC)
resource azurerm_user_assigned_identity agic {
  name = "id-${var.region_code}-${var.cluster_name}-aks-agic"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  tags = merge({ "Name" = "id-${var.region_code}-${var.cluster_name}-aks-gic"}, local.module_common_tags)
}

# fetch the resource group of the application gateway in front of the AKS cluster
data azurerm_resource_group agw_resource_group {
  name = azurerm_application_gateway.cluster_agw.resource_group_name
}

# allow managed identity for Application Gateway Ingress Controller to manage the application gateway in front of the AKS cluster
resource azurerm_role_assignment contributor_on_agw {
  principal_id = azurerm_user_assigned_identity.agic.principal_id
  role_definition_name = "Contributor"
  scope = data.azurerm_resource_group.agw_resource_group.id
}

# create sync point for all role assignments
resource null_resource wait_for_role_assignments_to_agic {
  triggers = {
    role_assignments = join(",", [azurerm_role_assignment.contributor_on_agw.id])
  }
}

output aks_managed_identity_agic {
  value = azurerm_user_assigned_identity.agic
}
