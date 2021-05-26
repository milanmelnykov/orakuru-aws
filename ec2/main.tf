variable "app" {}
variable "owner" {}
variable "environment" {}

variable "vpc_id" {}
variable "subnet_id" {}

variable "ec2_sg_id" {}
variable "monitoring_sg_id" {}

variable "ubuntu_ami" {}
variable "key_name" {}
variable "default_user" {}

# ork node
variable "instance_type" {}
variable "volume_specs" {}

# monitoring node
variable "instance_type_monitoring" {}
variable "volume_specs_monitoring" {}


resource "aws_instance" "ec2" {
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.ec2_sg_id]
  subnet_id              = var.subnet_id

  user_data = templatefile("./ec2/user_data.tpl", {
    DEFAULT_USER = var.default_user
  })

  root_block_device {
    volume_type = var.volume_specs.type
    volume_size = var.volume_specs.size
  }

  tags = {
    Name        = format("%s_ec2", var.app)
    Owner       = var.owner
    Environment = var.environment
  }

  depends_on = [var.subnet_id]
}

resource "aws_instance" "ec2_monitoring" {
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type_monitoring
  key_name               = var.key_name
  vpc_security_group_ids = [var.monitoring_sg_id]
  subnet_id              = var.subnet_id

  user_data = templatefile("./ec2/user_data_monitoring.tpl", {
    DEFAULT_USER       = var.default_user,
    EC2_ORK_PRIVATE_IP = aws_instance.ec2.private_ip
  })

  root_block_device {
    volume_type = var.volume_specs_monitoring.type
    volume_size = var.volume_specs_monitoring.size
  }

  tags = {
    Name        = format("%s_ec2_monitoring", var.app)
    Owner       = var.owner
    Environment = var.environment
  }

  depends_on = [var.subnet_id]
}