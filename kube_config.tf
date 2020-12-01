# creates a kube config file with the configuration of the newly created cluster at the specified location
resource local_file kube_config {
  content = azurerm_kubernetes_cluster.cluster.kube_config_raw
  filename = var.kube_config_filename
}
