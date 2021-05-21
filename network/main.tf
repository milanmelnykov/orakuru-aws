variable "app" {}
variable "owner" {}
variable "environment" {}
variable "availability_zone" {}
variable "vpc_cidr_block" {}
variable "pub_subnet_cidr_block" {}


resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false

  tags = {
    Name        = format("%s_vpc", var.app)
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = format("%s_igw", var.app)
    Owner       = var.owner
    Environment = var.environment
  }
}

# public subnet #######################################
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = format("%s_public_subnet", var.app)
    Owner       = var.owner
    Environment = var.environment
  }
}

# public network settings #############################
# route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = format("%s_public_route_table", var.app)
    Owner       = var.owner
    Environment = var.environment
  }
}

# route mappings
resource "aws_route" "public_route_for_internet_gateway" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"

  /* tags = {
    Name        = format("%s_public_route_for_internet_gateway", var.app)
    Owner       = var.owner
    Environment = var.environment
  } */
}

# attaching route table
resource "aws_route_table_association" "association_table_to_public_subnet" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public.id

  /* tags = {
    Name        = format("%s_association_table_to_public_subnet", var.app)
    Owner       = var.owner
    Environment = var.environment
  } */
}
