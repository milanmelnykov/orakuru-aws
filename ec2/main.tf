variable "app" {}
variable "owner" {}
variable "environment" {}

variable "vpc_id" {}
variable "subnet_id" {}

variable "sg_id" {}

variable "key_name" {}
variable "default_user" {}
variable "instance_type" {}
variable "ubuntu_ami" {}
variable "volume_specs" {}


resource "aws_instance" "ec2" {
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]
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
