resource azurerm_user_assigned_identity pod_identity {
  name = "id-${var.region_code}-${var.cluster_name}-aks-aadpodid"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  tags = merge({ "Name" = "id-${var.region_code}-${var.cluster_name}-aks-aadpodid"}, local.module_common_tags)
}

data azurerm_resource_group cluster_resource_group {
  name = azurerm_kubernetes_cluster.cluster.resource_group_name
}

data azurerm_resource_group node_resource_group {
  name = azurerm_kubernetes_cluster.cluster.node_resource_group
}

# allow AKS managed identity for kubelet to manage managed identities of node resource group
resource azurerm_role_assignment contributor_on_nodes {
  principal_id = azurerm_user_assigned_identity.pod_identity.principal_id
  role_definition_name = "Contributor"
  scope = data.azurerm_resource_group.node_resource_group.id
}

# allow AKS managed identity for kubelet to manage managed identities of node resource group
resource azurerm_role_assignment managed_identity_operator_on_nodes {
  principal_id = azurerm_user_assigned_identity.pod_identity.principal_id
  role_definition_name = "Managed Identity Operator"
  scope = data.azurerm_resource_group.node_resource_group.id
}

# allow AKS managed identity for kubelet to manage managed identities of cluster resource group
resource azurerm_role_assignment managed_identity_operator_on_cluster {
  principal_id = azurerm_user_assigned_identity.pod_identity.principal_id
  role_definition_name = "Managed Identity Operator"
  scope = data.azurerm_resource_group.cluster_resource_group.id
}

# allow AKS managed identity for kubelet to manage virtual machines in node resource group
resource azurerm_role_assignment virtual_machine_contributor {
  principal_id = azurerm_user_assigned_identity.pod_identity.principal_id
  role_definition_name = "Virtual Machine Contributor"
  scope = data.azurerm_resource_group.node_resource_group.id
}

# create sync point for all role assignments
resource null_resource wait_for_role_assignments_to_pod_identity {
  triggers = {
    role_assignments = join(",", [azurerm_role_assignment.contributor_on_nodes.id, azurerm_role_assignment.managed_identity_operator_on_cluster.id, azurerm_role_assignment.managed_identity_operator_on_nodes.id, azurerm_role_assignment.virtual_machine_contributor.id])
  }
}

output aks_managed_identity_pod_identity {
  value = azurerm_user_assigned_identity.pod_identity
}
