variable "db_info" {
  type = object({
    name     = string
    username = string
    password = string
  })
}
