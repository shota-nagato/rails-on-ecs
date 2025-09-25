output "rails_master_key_name" {
  value = aws_ssm_parameter.rails_master_key.name
}

output "database_url_name" {
  value = aws_ssm_parameter.database_url.name
}
