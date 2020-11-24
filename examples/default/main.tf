# Configure the Azure Provider
provider azurerm {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~> 2.20"
  features {}
}

provider local {
  version = "~> 2.0.0"
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
}

resource local_file kube_config {
  content = module.aks.aks_kube_config
  filename = "${path.module}/${module.aks.aks_name}.yaml"
}
