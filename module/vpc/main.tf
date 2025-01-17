resource "aws_vpc" "main" {
  cidr_block = var.cidr_vpc
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.cidr_public_subnet
  availability_zone = var.availability_zone_public_subnet
  map_public_ip_on_launch = true
  tags = {
    Name = var.pub_sub_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.cidr_private_sub
  availability_zone = var.availability_zone_private_sub
  tags = {
    Name = var.private_sub_name
  }
}

