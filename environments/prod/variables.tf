variable "secrets" {
  type = object({
    rails_master_key = string
  })
}

variable "db_info" {
  type = object({
    name     = string
    username = string
    password = string
  })
}
