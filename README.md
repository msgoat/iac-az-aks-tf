# iac-az-aks-tf Azure AKS Terraform Module

This Terraform module creates an Azure AKS instance with a basic setup.

## TODO's

| TODO | Status | Remark |
| --- | --- | --- |
| enable Azure CNI | done | prerequisite for Azure AD Pod Identity |
| deploy Azure AD Pod Identity | done | prerequisite for Application Gateway Ingress Controller |
| deploy Application Gateway Ingress Controller | in progress | needs a managed identity |
| make sure Kubernetes RBAC is enabled | done | |
| check if fully signed SSL certificates are supported by KeyVault | done | yes they are supported by only with commercial CAs like DigiCert |
* make cluster domain for DNS names configurable with a default of "k8s.azure.msgoat.eu"
* check if fully signed SSL certificates are supported by KeyVault 
* add worker node disk encryption with customer managed key
