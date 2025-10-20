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

module "route53" {
  source      = "../../modules/route53"
  domain_name = var.domain_name
  common      = local.common
}
