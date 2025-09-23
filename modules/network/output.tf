output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = values(aws_subnet.public)[*].id
}

output "security_group_alb_id" {
  value = aws_security_group.alb.id
}
