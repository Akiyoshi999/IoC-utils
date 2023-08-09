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
# locals {
#   subnets = {
#     public = {
#       "1a" = {
#         cidr   = "192.168.1.0/24"
#         az     = "ap-northeast-1a"
#         public = true
#       },
#       "1c" = {
#         cidr   = "192.168.2.0/24"
#         az     = "ap-northeast-1c"
#         public = true
#       },
#     }
#     private = {
#       name = "public"
#       cidr = "192.168.1.0/24"
#       az   = "ap-northeast-1a"
#     }
#   }
# }
resource "aws_subnet" "public_subnet" {
  for_each                = local.subnets.public
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

resource "aws_subnet" "private_subnet" {
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