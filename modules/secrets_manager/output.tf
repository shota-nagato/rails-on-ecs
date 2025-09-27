output "secret_for_db_credentials_arn" {
  value = aws_secretsmanager_secret.db_credentials.arn
}
