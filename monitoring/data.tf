data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = "${var.project}-${var.environment}"  # Change this to your EKS cluster name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

data "aws_acm_certificate" "acm" {
  domain = var.domain_name   # Use wildcard or specific domain
  types  = ["AMAZON_ISSUED"]    # Filter for Amazon-issued certificates
  most_recent = true            # Use the most recently issued certificate
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public_subnets.ids)
  id = each.value
}
