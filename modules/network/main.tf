resource "aws_vpc" "main" {
  cidr_block           = var.network.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-vpc"
  }
}

resource "aws_subnet" "public" {
  for_each          = toset(var.common.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.common.region}${each.value}"
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, index(var.common.availability_zones, each.value))

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-public-subnet-1${each.value}"
  }
}

resource "aws_subnet" "ecs" {
  for_each          = toset(var.common.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.common.region}${each.value}"
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, index(var.common.availability_zones, each.value) + length(var.common.availability_zones))

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-private-subnet-ecs-1${each.value}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-igw"
  }
}

resource "aws_eip" "main" {
  for_each = aws_subnet.public
  domain   = "vpc"
}

resource "aws_nat_gateway" "main" {
  for_each      = aws_subnet.public
  subnet_id     = each.value.id
  allocation_id = aws_eip.main[each.key].id

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-natgw-1${each.key}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-public-rt"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# AZごとにNAT Gatewayを配置するため、ECS用のルートテーブルもAZごとに作成
resource "aws_route_table" "ecs" {
  for_each = aws_subnet.ecs
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-ecs-rt-1${each.key}"
  }
}

resource "aws_route" "ecs" {
  for_each               = aws_route_table.ecs
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.main[each.key].id
}

resource "aws_route_table_association" "ecs" {
  for_each       = aws_subnet.ecs
  subnet_id      = each.value.id
  route_table_id = aws_route_table.ecs[each.key].id
}
