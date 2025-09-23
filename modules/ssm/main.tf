resource "aws_ssm_parameter" "rails_master_key" {
  name  = "/${var.common.prefix}/${var.common.environment}/rails_master_key"
  type  = "SecureString"
  value = "dummy_master_key"

  lifecycle {
    ignore_changes = [value]
  }
}
