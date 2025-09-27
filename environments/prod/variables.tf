variable "secrets" {
  type = object({
    rails_master_key = string
  })

  sensitive = true
}

variable "db_info" {
  type = object({
    db_name  = string
    username = string
    password = string
  })

  sensitive = true
}
