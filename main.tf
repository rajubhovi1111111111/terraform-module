provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block           = var.cidr_block
  vpc_name             = var.vpc_name
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  availability_zones = element(var.availability_zones, count.index)
  region = var.region

  providers = {
    aws = aws
  }
}

module "public_ec2" {
  source = "./modules/ec2"

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  subnet_id        = element(module.vpc.public_subnets, 0)
  key_name         = var.key_name
  instance_name    = "public-instance"
  security_group_ids = [aws_security_group.allow_http.id]

  providers = {
    aws = aws
  }
}

module "private_ec2" {
  source = "./modules/ec2"

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  subnet_id        = element(module.vpc.private_subnets, 0)
  key_name         = var.key_name
  instance_name    = "private-instance"
  security_group_ids = [aws_security_group.allow_http.id]

  providers = {
    aws = aws
  }
}

resource "aws_security_group" "allow_http" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "allow_http"
  }
}

output "public_instance_id" {
  value = module.public_ec2.instance_id
}

output "private_instance_id" {
  value = module.private_ec2.instance_id
}

output "public_instance_ip" {
  value = module.public_ec2.public_ip
}
