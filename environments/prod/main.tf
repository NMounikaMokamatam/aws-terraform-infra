terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = { source = "hashicorp/aws"; version = "~> 5.0" }
  }
  backend "s3" {
    bucket         = "my-terraform-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = "prod"
      ManagedBy   = "terraform"
      Owner       = "platform-team"
    }
  }
}

module "vpc" {
  source               = "../../modules/vpc"
  environment          = "prod"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

module "eks" {
  source              = "../../modules/eks"
  environment         = "prod"
  cluster_name        = "prod-eks-cluster"
  cluster_version     = "1.29"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  node_instance_types = ["m5.xlarge"]
  node_desired_size   = 3
  node_min_size       = 2
  node_max_size       = 10
}
