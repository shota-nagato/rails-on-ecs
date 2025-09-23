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
