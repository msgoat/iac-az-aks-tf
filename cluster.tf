# create a AKS cluster instance

resource azurerm_kubernetes_cluster cluster {
  name = "aks-${var.region_code}-${var.cluster_name}"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  dns_prefix = var.cluster_name
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
    type = "SystemAssigned"
  }
/*
  network_profile {
    load_balancer_profile {

    }
  }
*/
  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }
}
