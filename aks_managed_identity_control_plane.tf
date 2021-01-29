resource azurerm_user_assigned_identity cluster {
  name = "id-${var.region_code}-${var.cluster_name}-aks"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  tags = merge({ "Name" = "id-${var.region_code}-${var.cluster_name}-aks"}, local.module_common_tags)
}

# allow managed identity for AKS cluster to access network resources hosting the AKS cluster to allow AKS to create an internal load balancer
resource azurerm_role_assignment vnet_owner {
  principal_id = azurerm_user_assigned_identity.cluster.principal_id
  role_definition_name = "Owner"
  scope = azurerm_virtual_network.vnet.id # data.azurerm_virtual_network.owner_scope.id
}

# create sync point for all role assignments
resource null_resource wait_for_role_assignments_to_control_plane {
  triggers = {
    role_assignments = join(",", [azurerm_role_assignment.vnet_owner.id])
  }
}

output aks_managed_identity_control_plane {
  value = azurerm_user_assigned_identity.cluster
}

