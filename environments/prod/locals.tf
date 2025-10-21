locals {
  common = {
    prefix             = "knorbly"
    environment        = "prod"
    region             = "ap-northeast-1"
    availability_zones = ["a", "c"]
  }

  network = {
    vpc_cidr = "10.0.0.0/20"
  }

  domain_name = var.domain_settings.base_domain
}
