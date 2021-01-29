terraform {
  required_providers {
    azurerm = {
      version = "~> 2.43"
    }
    local = {
      version = "~> 2.0"
    }
    helm = {
      version = "~> 1.3"
    }
    kubernetes = {
      version = "~> 1.13"
    }
    null = {
      version = "~> 3.0"
    }
  }
}

locals {
  module_common_tags = {
    Organization = var.organization_name
    Department = var.department_name
    Project = var.project_name
    Stage = var.stage
  }
}
