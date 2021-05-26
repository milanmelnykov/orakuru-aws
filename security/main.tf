variable "app" {}
variable "owner" {}
variable "environment" {}
variable "vpc_id" {}

# Security Group for ec2 -- orakuru node
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

# ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# bsc
    ingress {
    from_port   = 8576
    to_port     = 8576
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# expose metrics to monitoring node
    ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_monitoring_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = format("%s_ec2_sg", var.app)
    Owner       = var.owner
    Environment = var.environment
  }
}

# Security Group for ec2 -- monitoring node
resource "aws_security_group" "ec2_monitoring_sg" {
  vpc_id = var.vpc_id

# ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# bsc
    ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = format("%s_ec2_monitoring_sg", var.app)
    Owner       = var.owner
    Environment = var.environment
  }
}
/* 
# Security Group for ec2s -- allow communication between ec2s inside same sg
resource "aws_security_group" "ec2_communication_sg" {
  vpc_id = var.vpc_id

# bsc
    ingress {
    from_port   = -1
    to_port     = -1
    protocol    = -1
    security_groups = []
  }


  tags = {
    Name        = format("%s_ec2_communication_sg", var.app)
    Owner       = var.owner
    Environment = var.environment
  }
} */
