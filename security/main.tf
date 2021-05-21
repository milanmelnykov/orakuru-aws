variable "app" {}
variable "owner" {}
variable "environment" {}
variable "vpc_id" {}

# Security Group for EC2 #######################################################
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name        = format("%s_ec2_sg", var.app)
    Owner       = var.owner
    Environment = var.environment
  }
}
