provider "aws" {
  region = var.aws_region
}

module "network" {
  app                   = var.app
  owner                 = var.owner
  environment           = var.environment
  availability_zone     = var.availability_zone
  vpc_cidr_block        = var.vpc_cidr_block
  pub_subnet_cidr_block = var.pub_subnet_cidr_block
  source                = "./network"
}

module "security" {
  app         = var.app
  owner       = var.owner
  environment = var.environment
  vpc_id      = module.network.vpc_id
  source      = "./security"
}

module "ec2" {
  app           = var.app
  owner         = var.owner
  environment   = var.environment
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.public_subnet_id
  ec2_sg_id     = module.security.ec2_sg_id
  monitoring_sg_id = module.security.monitoring_sg_id
  ubuntu_ami    = var.ubuntu_ami
  default_user  = var.default_user
  key_name      = var.key_name
  # ork node
  instance_type = var.instance_type
  volume_specs  = var.volume_specs
  # monitoring node
  instance_type_monitoring = var.instance_type_monitoring
  volume_specs_monitoring  = var.volume_specs_monitoring
  source        = "./ec2"
}


