variable "common" {
  type = object({
    prefix      = string
    environment = string
    region      = string
  })
}

variable "ecr_repository_url" {
  type = string
}

variable "network" {
  type = object({
    private_esc_subnet_ids = list(string)
    security_group_ecs_id  = string
  })
}

variable "alb" {
  type = object({
    alb_target_group_arn = string
  })
}

variable "ssm" {
  type = object({
    rails_master_key_name = string
  })
}

variable "secrets_manager" {
  type = object({
    secret_for_db_credentials_arn = string
  })
}

