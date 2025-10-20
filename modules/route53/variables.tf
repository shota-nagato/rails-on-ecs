variable "common" {
  type = object({
    prefix      = string
    environment = string
  })
}

variable "domain_name" {
  type = string
}
