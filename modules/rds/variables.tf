variable "common" {
  type = object({
    prefix      = string
    environment = string
  })
}

variable "network" {
  type = object({
    private_rds_subnet_ids = list(string)
    security_group_rds_id  = string
  })
}

variable "db_info" {
  type = object({
    name     = string
    username = string
    password = string
  })
}
