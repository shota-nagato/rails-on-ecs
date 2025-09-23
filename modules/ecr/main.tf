resource "aws_ecr_repository" "rails" {
  name                 = "${var.common.prefix}-${var.common.environment}-rails"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  encryption_configuration {
    encryption_type = "KMS"
  }
}
