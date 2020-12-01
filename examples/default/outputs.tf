output aks_name {
  description = "fully qualified name of the AKS cluster"
  value = module.aks.aks_name
}

output aks_loadbalancer_id {
  description = "unique identifier of the AKS managed loadbalancer"
  value = module.aks.aks_loadbalancer_id
}

output aks_loadbalancer_ip {
  description = "fully qualified name of the AKS cluster"
  value = module.aks.aks_loadbalancer_ip
}

output ingress_ip_address {
  value = module.aks.ingress_ip_address
}