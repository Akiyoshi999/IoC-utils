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
resource "aws_subnet" "public_subnet_1a" {
  for_each = {
    "192.168.1.0/24" = "ap-northeast-1a"
    "192.168.2.0/24" = "ap-northeast-1c"
  }
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value
  cidr_block              = each.key
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-${var.environment}-${var.public}-${each.value}"
    Project = var.project
    Env     = var.environment
    Type    = var.public
  }
}

resource "aws_subnet" "private_subnet_1a" {
  for_each = {
    "192.168.3.0/24" = "ap-northeast-1a"
    "192.168.4.0/24" = "ap-northeast-1c"
  }
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value
  cidr_block              = each.key
  map_public_ip_on_launch = false
  tags = {
    Name    = "${var.project}-${var.environment}-${var.private}-${each.value}"
    Project = var.project
    Env     = var.environment
    Type    = var.private
  }
}

# Route table