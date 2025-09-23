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
    vpc_cidr = string
  })
}
