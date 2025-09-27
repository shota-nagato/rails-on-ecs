resource "aws_db_subnet_group" "main" {
  name       = "${var.common.prefix}-${var.common.environment}-rds-subnet-group"
  subnet_ids = var.network.private_rds_subnet_ids
}

resource "aws_db_instance" "main" {
  identifier = "${var.common.prefix}-${var.common.environment}-rds"

  engine            = "postgres"
  engine_version    = "16.9"
  instance_class    = "db.t4g.micro"
  allocated_storage = 20
  storage_type      = "gp3"

  # 本番環境では変更すること
  skip_final_snapshot = true

  db_name  = var.db_info.db_name
  username = var.db_info.username
  password = var.db_info.password
  port     = 5432

  vpc_security_group_ids = [var.network.security_group_rds_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-rds"
  }
}
