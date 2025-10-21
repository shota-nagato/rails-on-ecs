variable "common" {
  type = object({
    prefix      = string
    environment = string
  })
}

variable "acm_settings" {
  type = object({
    domain_name = string
  })
}
