# VPC
resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false
  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# Subnets

resource "aws_subnet" "public_subnets" {
  for_each = local.subnets.public

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = each.value.public
  tags = {
    Name    = "${var.project}-${var.environment}-${var.public}-${each.value.az}"
    Project = var.project
    Env     = var.environment
    Type    = var.public
  }
}

resource "aws_subnet" "private_subnets" {
  for_each                = local.subnets.private
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = each.value.public
  tags = {
    Name    = "${var.project}-${var.environment}-${var.private}-${each.value.az}"
    Project = var.project
    Env     = var.environment
    Type    = var.private
  }
}

# Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-${var.public}-rt"
    Project = var.project
    Env     = var.environment
    Type    = var.public
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-${var.private}-rt"
    Project = var.project
    Env     = var.environment
    Type    = var.private
  }
}

resource "aws_route_table_association" "public_rt" {
  for_each       = aws_subnet.public_subnets
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = each.value.id
}
resource "aws_route_table_association" "private_rt" {
  for_each       = aws_subnet.private_subnets
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = each.value.id
}