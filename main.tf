module "vpc" {
  source = "./modules/vpc"
  project_prefix = var.project_prefix
  vpc_cidr = "10.0.0.0/16"
  availability_zones = ["ap-south-1a","ap-south-1b"]
}

module "compute" {
  source = "./modules/compute"
  project_prefix = var.project_prefix
  public_subnet_ids = module.vpc.public_subnets
  app_private_subnets = module.vpc.app_private_subnets
  vpc_id = module.vpc.vpc_id
  public_key_path = var.public_key_path
  ami = var.ami
  instance_type = var.instance_type
  rds_endpoint = module.rds.endpoint
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  alb_sg_id = module.compute.alb_sg_id
}

resource "aws_lb_target_group_attachment" "app_tg_attach" {
  count = length(module.compute.app_instance_ids)
  target_group_arn = module.alb.app_target_group_arn
  target_id        = element(module.compute.app_instance_ids, count.index)
  port             = 80
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  db_subnet_ids = module.vpc.db_private_subnets
  db_name = "mydbproject"
  username = "admin"
  password = "admin1234" # lab only: change for real use or use Terraform sensitive var / secrets manager
}

# Allow RDS SG inbound only from app security group
resource "aws_security_group_rule" "rds_allow_app" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.rds.db_sg_id
  source_security_group_id = module.compute.app_sg_id
}
