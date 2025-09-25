terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }
  }
}

provider "aws" {
  region                   = local.common.region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

module "network" {
  source = "../../modules/network"

  common  = local.common
  network = local.network
}

module "alb" {
  source = "../../modules/alb"

  common  = local.common
  network = module.network
}

module "ecr" {
  source = "../../modules/ecr"

  common = local.common
}

module "ecs" {
  source = "../../modules/ecs"

  common             = local.common
  network            = module.network
  alb                = module.alb
  ssm                = module.ssm
  ecr_repository_url = module.ecr.ecr_repository_url
}

module "ssm" {
  source = "../../modules/ssm"

  common      = local.common
  db_info     = var.db_info
  db_endpoint = module.rds.db_endpoint
}

module "rds" {
  source = "../../modules/rds"

  common  = local.common
  network = module.network
  db_info = var.db_info
}
