# general
variable "app" {
  default = "orakuru"
}

variable "owner" {
  default = "milan"
}

variable "environment" {
  default = "test"
}

# vpc
variable "aws_region" {
  default = "eu-central-1"
}

variable "availability_zone" {
  default = "eu-central-1a"
}

variable "vpc_cidr_block" {
  default = "172.30.0.0/16"
}

variable "pub_subnet_cidr_block" {
  default = "172.30.5.0/24"
}

# ec2
variable "instance_type" {
  default = "t3a.xlarge"
}

variable "ubuntu_ami" {
  default = "ami-05f7491af5eef733a" //x86 ubuntu 20.04 lts
}

variable "default_user" {
  default = "ubuntu"
}

variable "key_name" {
  default = "orakuru-ssh"
}

variable "volume_specs" {
  default = {
    type = "gp2",
    size = 100
  }
}
