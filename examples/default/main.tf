# Configure the Azure Provider
provider azurerm {
  features {}
}

provider local {
}

locals {
  main_common_tags = {
    Organization = var.organization_name
    Department = var.department_name
    Project = var.project_name
    Stage = var.stage
  }
}

# Create a new resource group if no resource group was specified
resource azurerm_resource_group owner {
  name = "rg-${var.region_code}-${var.cluster_name}"
  location = var.region_name
  tags = merge(map("Name", "rg-${var.region_code}-${var.cluster_name}"), local.main_common_tags)
}

module aks {
  source = "../.."
  cluster_name = var.cluster_name
  department_name = var.department_name
  network_cidr = var.network_cidr
  organization_name = var.organization_name
  project_name = var.project_name
  region_code = var.region_code
  region_name = var.region_name
  resource_group_name = azurerm_resource_group.owner.name
  resource_group_location = azurerm_resource_group.owner.location
  stage = var.stage
  kubernetes_version = var.kubernetes_version
  kube_config_filename = "${path.module}/output/aks-${var.region_code}-${var.cluster_name}.yaml"
  ingress_controller_type = "TRAEFIK"
  loadbalancer_type = "EXTERNAL"
}
