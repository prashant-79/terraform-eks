provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "Environment" = var.environment
      "Terraform"     = "true" # Add a key-value pair here
    }
  }
}
terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Allows any minor update within major version 5
    }
     helm = {
      source = "hashicorp/helm"
      version = "~>2.11.0"  # Use the latest version available
    }
  }
}