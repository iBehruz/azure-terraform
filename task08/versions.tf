terraform {
  backend "azurerm" {
    resource_group_name  = "rg-adolearn-31zawnrd-tfstate"
    storage_account_name = "tfstate31zawnrdsa"
    container_name       = "task8"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 1.5.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.110.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}
