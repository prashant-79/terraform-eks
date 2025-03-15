provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "Environment" = var.environment
      "Terraform"     = "true" # Add a key-value pair here
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubectl" {
    host                   = data.aws_eks_cluster.cluster.endpoint
  load_config_file       = false
  token  =data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
}


terraform {
  backend "s3"{}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Allows any minor update within major version 5
    }
     helm = {
      source = "hashicorp/helm"
      version = "~>2.11.0"  # Use the latest version available
    }
      kubectl = {
      source = "bnu0/kubectl"
      version = "0.27.0"
    }
  }
}