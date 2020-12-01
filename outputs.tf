
output "vnet_id" {
  description = "Unique identifier of the newly created VNet."
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Fully qualified name of the newly created VNet."
  value = azurerm_virtual_network.vnet.name
}

output "system_pool_subnet_id" {
  description = "Unique identifier of the system pool subnet"
  value = azurerm_subnet.system_pool.id
}

output "user_pool_subnet_id" {
  description = "Unique identifier of the user pool subnet"
  value = azurerm_subnet.user_pool.id
}

output "data_subnet_id" {
  description = "Unique identifier of the data subnet"
  value = azurerm_subnet.data.id
}

output aks_name {
  description = "fully qualified name of the AKS cluster"
  value = azurerm_kubernetes_cluster.cluster.name
}

output aks_kube_config {
  description = "kube config required to access the AKS cluster"
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
}
