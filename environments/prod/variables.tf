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

variable "domain_settings" {
  type = object({
    base_domain   = string
    domain_prefix = optional(string)
  })
}

