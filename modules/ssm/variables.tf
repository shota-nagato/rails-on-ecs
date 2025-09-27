variable "common" {
  type = object({
    prefix      = string
    environment = string
  })
}

variable "secrets" {
  type = object({
    rails_master_key = string
  })

  sensitive = true
}

variable "db_info" {
  type = object({
    name     = string
    username = string
    password = string
  })
}

variable "db_endpoint" {
  type = string
}
