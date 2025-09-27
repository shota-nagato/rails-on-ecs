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
