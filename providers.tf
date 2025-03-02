terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.5.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.14"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.3"
    }
  }
}

provider "kind" {}
provider "null" {}

provider "kubernetes" {
    config_path = "~/.kube/config"
    
}
provider "helm" {
    kubernetes {
        config_path = "~/.kube/config"
    }
}