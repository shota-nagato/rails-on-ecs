resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-route53-zone"
  }
}
