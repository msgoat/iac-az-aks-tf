variable region_name {
  description = "The Azure region to deploy into."
}

variable region_code {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
}

variable organization_name {
  description = "The name of the organization that owns all AWS resources."
}

variable department_name {
  description = "The name of the department that owns all AWS resources."
}

variable project_name {
  description = "The name of the project that owns all AWS resources."
}

variable stage {
  description = "The name of the current environment stage."
}

variable resource_group_name {
  description = "The name of the resource group supposed to own all allocated resources; will create a new resource group if not specified"
}

variable resource_group_location {
  description = "The location of the resource group supposed to own all allocated resources"
}

variable cluster_name {
  description = "name of the AKS cluster to create; will be prefixed according to naming convention"
}

variable network_cidr {
  description = "CIDR block of the network"
}

variable kubernetes_version {
  description = "Kubernetes version the AKS service instance should be based on"
}

variable system_pool_vm_sku {
  description = "VM instance size to be used for nodes in the systen pool"
  default = "Standard_D2s_v3"
}

variable system_pool_min_size {
  description = "minimum number of nodes in the system pool"
  type = number
  default = 2
}

variable system_pool_desired_size {
  description = "desired number of nodes in the system pool"
  type = number
  default = 2
}

variable system_pool_max_size {
  description = "maximum number of nodes in the system pool"
  type = number
  default = 6
}

variable system_pool_os_disk_size {
  description = "OS disk size of nodes in the system pool in GB"
  type = number
  default = 512
}

variable user_pool_vm_sku {
  description = "VM instance size to be used for nodes in the systen pool"
  default = "Standard_D2s_v3"
}

variable user_pool_min_size {
  description = "minimum number of nodes in the user pool"
  type = number
  default = 3
}

variable user_pool_desired_size {
  description = "desired number of nodes in the user pool"
  type = number
  default = 3
}

variable user_pool_max_size {
  description = "maximum number of nodes in the user pool"
  type = number
  default = 10
}

variable user_pool_os_disk_size {
  description = "OS disk size of nodes in the user pool in GB"
  type = number
  default = 512
}

variable user_pool_with_spot_instances {
  description = "controls if the user pool should be based on spot or regular instances"
  type = bool
  default = false
}

variable kube_config_filename {
  description = "defines the location the kubeconfig file for the newly created cluster should be written to"
}
