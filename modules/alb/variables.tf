variable "common" {
  type = object({
    prefix             = string
    environment        = string
    region             = string
    availability_zones = list(string)
  })
}

variable "network" {
  type = object({
    vpc_id                = string
    public_subnet_ids     = list(string)
    security_group_alb_id = string
  })
}
