output aks_name {
  description = "fully qualified name of the AKS cluster"
  value = module.aks.aks_name
}

output aks_managed_identity_id {
  description = "unique identifier of the system assigned managed identity running the AKS cluster"
  value = module.aks.aks_managed_identity_id
}

output ingress_controller_dns {
  value = module.aks.ingress_controller_dns
}

output ingress_controller_ip {
  value = module.aks.ingress_controller_ip
}

output aks_managed_identity_control_plane {
  value = module.aks.aks_managed_identity_control_plane
}

output aks_managed_identity_kubelet {
  value = module.aks.aks_managed_identity_kubelet
}

output aks_managed_identity_pod_identity {
  value = module.aks.aks_managed_identity_pod_identity
}

