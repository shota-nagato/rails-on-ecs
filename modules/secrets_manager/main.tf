resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.common.prefix}-${var.common.environment}-db-credentials"
  description = "Database credentials for ${var.common.prefix} ${var.common.environment} environment"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    host     = var.rds.db_instance_address
    db_name  = var.db_info.db_name
    username = var.db_info.username
    password = var.db_info.password
  })
}
