output aks_name {
  description = "fully qualified name of the AKS cluster"
  value = module.aks.aks_name
}

output ingress_ip_address {
  value = module.aks.ingress_ip_address
}