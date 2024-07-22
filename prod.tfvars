region               = "ap-south-1"
cidr_block           = "10.0.0.0/16"
vpc_name             = "my-vpc"
public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
public_subnet_count  = 2
private_subnet_count = 2
availability_zones   = ["ap-south-1a", "ap-south-1b"]
