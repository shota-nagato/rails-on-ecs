variable "common" {
  type = object({
    prefix      = string
    environment = string
  })
}

variable "db_info" {
  type = object({
    db_name  = string
    username = string
    password = string
  })
}

variable "rds" {
  type = object({
    db_instance_address = string
  })
}
