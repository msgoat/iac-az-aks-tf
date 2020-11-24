# create a user node group or user pool
resource azurerm_kubernetes_cluster_node_pool user {
  name = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  mode = "User"
  vm_size = var.user_pool_vm_sku
  availability_zones = ["1", "2", "3"]
  enable_auto_scaling = true
  max_count = var.user_pool_max_size
  min_count = var.user_pool_min_size
  node_count = var.user_pool_desired_size
  orchestrator_version = var.kubernetes_version
  os_disk_size_gb = var.user_pool_os_disk_size
  os_type = "Linux"
  priority = var.user_pool_with_spot_instances ? "Spot" : "Regular"
  vnet_subnet_id = azurerm_subnet.user_pool.id

  lifecycle {
    ignore_changes = [node_count]
  }
}
