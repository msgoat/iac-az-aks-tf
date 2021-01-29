# assigns additional roles to AKS managed identity for kubelet
# retrieve the AKS managed identity for kubelet
data azurerm_user_assigned_identity kubelet {
  name = "${azurerm_kubernetes_cluster.cluster.name}-agentpool"
  resource_group_name = azurerm_kubernetes_cluster.cluster.node_resource_group
}
/*
data azurerm_resource_group cluster_resource_group {
  name = azurerm_kubernetes_cluster.cluster.resource_group_name
}

data azurerm_resource_group node_resource_group {
  name = azurerm_kubernetes_cluster.cluster.node_resource_group
}

# allow AKS managed identity for kubelet to manage managed identities of node resource group
resource azurerm_role_assignment managed_identity_operator_on_nodes {
  principal_id = data.azurerm_user_assigned_identity.kubelet.principal_id
  role_definition_name = "Managed Identity Operator"
  scope = data.azurerm_resource_group.node_resource_group.id
}

# allow AKS managed identity for kubelet to manage managed identities of cluster resource group
resource azurerm_role_assignment managed_identity_operator_on_cluster {
  principal_id = data.azurerm_user_assigned_identity.kubelet.principal_id
  role_definition_name = "Managed Identity Operator"
  scope = data.azurerm_resource_group.cluster_resource_group.id
}

# allow AKS managed identity for kubelet to manage virtual machines in node resource group
resource azurerm_role_assignment virtual_machine_contributor {
  principal_id = data.azurerm_user_assigned_identity.kubelet.principal_id
  role_definition_name = "Virtual Machine Contributor"
  scope = data.azurerm_resource_group.node_resource_group.id
}

# create sync point for all role assignments
resource null_resource wait_for_role_assignments_to_kubelet {
  triggers = {
    role_assignments = join(",", [azurerm_role_assignment.managed_identity_operator_on_cluster.id, azurerm_role_assignment.managed_identity_operator_on_nodes.id, azurerm_role_assignment.virtual_machine_contributor.id])
  }
}
*/

output aks_managed_identity_kubelet {
  value = data.azurerm_user_assigned_identity.kubelet
}
