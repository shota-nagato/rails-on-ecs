resource "aws_vpc" "main" {
  cidr_block           = var.network.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-vpc"
  }
}

resource "aws_subnet" "public_alb" {
  for_each          = toset(var.common.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.common.region}${each.value}"
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, index(var.common.availability_zones, each.value))

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-public-subnet-alb-1${each.value}"
  }
}

resource "aws_subnet" "private_ecs" {
  for_each          = toset(var.common.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.common.region}${each.value}"
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, index(var.common.availability_zones, each.value) + length(var.common.availability_zones))

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-private-subnet-ecs-1${each.value}"
  }
}
