# create a AKS cluster instance
resource azurerm_kubernetes_cluster cluster {
  name = "aks-${var.region_code}-${var.cluster_name}"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  dns_prefix = var.cluster_name
  # IMPORTANT: we need to pin the kubernetes version, otherwise Azure will determine it!
  kubernetes_version = var.kubernetes_version
  tags = merge(map("Name", "aks-${var.region_code}-${var.cluster_name}"), local.module_common_tags)

  # defines the system node group or system pool
  default_node_pool {
    name = "system"
    vm_size = var.system_pool_vm_sku
    availability_zones = ["1", "2", "3"]
    enable_auto_scaling = true
    min_count = var.system_pool_min_size
    node_count = var.system_pool_desired_size
    max_count = var.system_pool_max_size
    enable_node_public_ip = false
    orchestrator_version = var.kubernetes_version
    os_disk_size_gb = var.system_pool_os_disk_size
    type = "VirtualMachineScaleSets"
    vnet_subnet_id = azurerm_subnet.system_pool.id
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }
    azure_policy {
      enabled = false
    }
    http_application_routing {
      enabled = false
    }
    kube_dashboard {
      enabled = false
    }
    oms_agent {
      enabled = false
    }
  }

  identity {
    type = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.cluster.id
  }

  network_profile {
    # use Azure CNI network plugin which is recommended for secure baseline clusters
    network_plugin = "azure"
    # send outbound traffic through the AKS managed load balancer
    outbound_type = "loadBalancer"
    # use a standard load balancer
    load_balancer_sku = "Standard"
  }

  role_based_access_control {
    enabled = true
    /* TODO: activate Azure AD integration after all users got proper roles!!!
    azure_active_directory {
      managed = false
    }
    */
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      network_profile[0].load_balancer_profile[0].idle_timeout_in_minutes
    ]
  }

  depends_on = [null_resource.wait_for_role_assignments_to_control_plane]
}
