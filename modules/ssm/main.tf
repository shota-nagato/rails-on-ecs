resource "aws_ssm_parameter" "rails_master_key" {
  name  = "/${var.common.prefix}/${var.common.environment}/rails_master_key"
  type  = "SecureString"
  value = var.secrets.rails_master_key

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "database_url" {
  name  = "/${var.common.prefix}/${var.common.environment}/database_url"
  type  = "SecureString"
  value = "postgresql://${var.db_info.username}:${var.db_info.password}@${var.db_endpoint}:5432/${var.db_info.name}"
}
