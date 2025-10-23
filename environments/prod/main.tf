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
  secrets_manager    = module.secrets_manager
  ecr_repository_url = module.ecr.ecr_repository_url
}

module "ssm" {
  source = "../../modules/ssm"

  common  = local.common
  secrets = var.secrets
}

module "secrets_manager" {
  source = "../../modules/secrets_manager"

  common  = local.common
  rds     = module.rds
  db_info = var.db_info
}

module "rds" {
  source = "../../modules/rds"

  common  = local.common
  network = module.network
  db_info = var.db_info
}

module "acm" {
  source = "../../modules/acm"

  common = local.common
  acm_settings = {
    domain_name = local.domain_name
  }
}

module "s3_logs" {
  source = "../../modules/s3_logs"

  common = local.common
}
