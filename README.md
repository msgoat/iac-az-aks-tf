# iac-az-aks-tf Azure AKS Terraform Module

This Terraform module creates an Azure AKS instance with a basic setup.

## TODO's

* allow AKS to join PIP of AKS manages LoadBalancer
* connect Azure Application Gateway to AKS managed Loadbalancer
* make cluster domain for DNS names configurable with a default of "k8s.azure.msgoat.eu"
* make sure Kubernetes RBAC is enabled
* check if fully signed SSL certificates are supported by KeyVault 
* add worker node disk encryption with customer managed key
